///compression notes
//	slopeAbove:
//4" → 0.35–0.45
//5" → 0.45–0.60
//8" → 0.60–0.80
		///the larger the speaker cone the more relax time is possible and less difference between slopes, also less threshhold//Relax time ≈ 5–10× the attack time
//clampTime (attack)
//Fast attack → kills transients → fewer high-frequency spikes
//Slow attack → transients pass → brighter sound
//relaxTime (release)
//Fast release → pumping, rhythmic spectral motion
//Slow release → smoother, denser spectrum
//Relax too short (< 80 ms)
//Bass “breathes”
//Mids wobble
//Small speakers sound cheap
//Relax too long (> 300 ms)
//Bass dominates gain control
//Mix sounds flat, distant
//Quiet detail doesn’t recover fast enough
//tanh saturation mul less as speaker size increase///

///quaterion rhtyhm solid rotation
/*(var i=Quaternion(0, axis_xyz.[0], 0, 0),j=Quaternion(0, 0, axis_xyz.[1], 0),k=Quaternion(0, 0, 0, axis_xyz.[2]);

axis=i+j+k;
~x1=tetrahedron.collect{
	plx1=plx1+1;
	qx1=Quaternion(0,Spherical(1,~az1[plx1],~el1[plx1]).x.round(0.00001),Spherical(1,~az1[plx1],~el1[plx1]).y.round(0.00001),Spherical(1,~az1[plx1],~el1[plx1]).z.round(0.00001));
	rotor_a=((axis*exp(Complex(0,1)*angle_a.degrad).imag)+exp(Complex(0,1)*angle_a.degrad).real); ax=rotor_a*qx1*rotor_a.conjugate;
	ax.b.round(0.00001);
};
)*/



(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=2;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*4;
s.options.blockSize = 64;
s.options.maxNodes = 1024 * 2;
//s.makeGui(w);
s.options.sampleRate= 44100;
//s.recHeaderFormat="aiff";
//s.recSampleFormat ="int16";
//s.recChannels = 8;
//s.boot;
);
(
s.waitForBoot{
	//Buffer.freeAll;
(
(
~n=1.neg;~array=992.collect{~n=~n+1;2.pow(~n/992)};
~a=(0-(pi/496)); ~ph=992.collect{~a=~a+(pi/496);};
~bufferSize = 4096*8;
~signalSize = 2048*8;
);
(
~w1= Buffer.alloc(s,~bufferSize);
		{
	var signal,wt;
	signal=Signal.sineFill(~signalSize,~array,~ph);

wt = signal.asWavetable;
~w1.loadCollection(wt);
//signal.plot;
		}.value;
);
);


//////kick
 (
SynthDef(\kick, {
	arg amp=20,n=12,pan=1,low=0,noise=0.001,decay=1,m=1;
    var env,sig,freq,anglex,angley,anglez,mod_anglex,mod_angley,mod_anglez,fund=28,mx,my,mz,magx,magz,magy;
	var sph,control,phase,threshold=(((343/0.14)/20).reciprocal.ampdb/2.sqrt).dbamp,ton=2.pow(n/12),az=pi,el=pi/2;

	freq = EnvGen.kr(Env([fund*ton, fund], [decay/8], curve: -4)); // pitch drop
	env= EnvGen.kr(Env.perc(0.01, decay, curve: -4),doneAction:2,levelScale:amp);


					az=SinOsc.ar(pan/2,0).range(pi,pi.neg);
			el=SinOsc.ar(pan/2,pi/2,pan.reciprocal).range((pi/2),(pi/2).neg);

		sph=Spherical(1,(az.lag(0.01)),(el.lag(0.01)));

anglex=exp(Complex(0,1)*sph.theta).real*exp(Complex(0,1)*sph.phi).real;
angley=exp(Complex(0,1)*sph.theta).imag*exp(Complex(0,1)*sph.phi).real;
anglez=exp(Complex(0,1)*sph.phi).imag;

mod_anglex=SinOsc.ar(pan,Complex(anglex,angley).theta,pan.reciprocal).range(pi.neg,pi);
mod_angley=SinOsc.ar(pan,Complex(angley,anglex).theta,pan.reciprocal).range(pi.neg,pi);
mod_anglez=SinOsc.ar(pan,Complex(0,anglez).theta,pan.reciprocal).range((pi/2).neg,(pi/2));

magx=((Complex(cos(((sph.theta+mod_anglex).round(0.00001)*m).wrap(pi.neg,pi)),cos((((sph.theta+mod_anglex).round(0.00001)*m)).wrap(pi.neg,pi))).rho/(2.sqrt))*
	(Complex(cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

magy=((Complex(sin(((sph.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi)),sin(((sph.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi))).rho/(2.sqrt))*
		(Complex(cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

magz=((Complex(cos(((sph.phi+mod_anglez).round(0.00001)*m).wrap((pi/2).neg,(pi/2))),cos(((sph.phi).round(0.00001)*m).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

mx=(Cartesian(magx.value,0,0).rho);my=(Cartesian(0,magy.value,0).rho);mz=(Cartesian(0,0,magz.value).rho);



		sig=(LPF.ar((Osc.ar(~w1.bufnum,freq,phase:sph.theta-sph.phi,mul:100).abs*SinOsc.ar(freq,phase:sph.theta-sph.phi)),freq*2.pow(low.lag(0.01)/992),ton.reciprocal));

	control=SinOsc.ar(freq,sph.theta-sph.phi,ton.reciprocal);

sig = sig + (sig * BrownNoise.ar(noise));


	sig=HPF.ar(sig,50); sig=LPF.ar(sig,2000);
	sig=Compander.ar(sig,control,threshold,1,0.3,0.03,0.15);
	sig=tanh(sig*1.5);sig=Limiter.ar(sig,0.89,0.01);


		Out.ar(0, Pan2.ar(sig,anglex.round(0.0001)*mx,env));
		Out.ar(0, Pan2.ar(sig,angley.round(0.0001)*my,env));
		Out.ar(0, Pan2.ar(sig,anglez.round(0.0001)*mz,env));

}).add;);

Synth(\kick);

/////snare
(
SynthDef(\snare, {
	arg amp=1,n=48,pan=0.5,low=0,noise=0.1,decay=1,m=1,snare=8;
    var env,sig,freq,anglex,angley,anglez,mod_anglex,mod_angley,mod_anglez,fund=28,mx,my,mz,magx,magz,magy;
	var sph,control,phase,threshold=(((343/0.14)/20).reciprocal.ampdb/2.sqrt).dbamp,ton=2.pow(n/12),az=pi,el=pi/2;

	freq = EnvGen.kr(Env([fund*ton, fund], [decay/2], curve: -4));
	env= EnvGen.kr(Env.perc(0.01, decay),doneAction:2,levelScale:amp);

					az=SinOsc.ar(pan,0).range(pi,pi.neg);
			el=SinOsc.ar(pan,pi/2,pan.reciprocal).range((pi/2),(pi/2).neg);

sph=Spherical(1,(az.lag(0.01)),(el.lag(0.01)));

anglex=exp(Complex(0,1)*sph.theta).real*exp(Complex(0,1)*sph.phi).real;
angley=exp(Complex(0,1)*sph.theta).imag*exp(Complex(0,1)*sph.phi).real;
anglez=exp(Complex(0,1)*sph.phi).imag;

mod_anglex=SinOsc.ar(pan,Complex(anglex,angley).theta,pan.reciprocal).range(pi.neg,pi);
mod_angley=SinOsc.ar(pan,Complex(angley,anglex).theta,pan.reciprocal).range(pi.neg,pi);
mod_anglez=SinOsc.ar(pan,Complex(0,anglez).theta,pan.reciprocal).range((pi/2).neg,(pi/2));

magx=((Complex(cos(((sph.theta+mod_anglex).round(0.00001)*m).wrap(pi.neg,pi)),cos((((sph.theta+mod_anglex).round(0.00001)*m)).wrap(pi.neg,pi))).rho/(2.sqrt))*
	(Complex(cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

magy=((Complex(sin(((sph.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi)),sin(((sph.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi))).rho/(2.sqrt))*
		(Complex(cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

magz=((Complex(cos(((sph.phi+mod_anglez).round(0.00001)*m).wrap((pi/2).neg,(pi/2))),cos(((sph.phi).round(0.00001)*m).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

mx=(Cartesian(magx.value,0,0).rho);my=(Cartesian(0,magy.value,0).rho);mz=(Cartesian(0,0,magz.value).rho);


	sig=(LPF.ar((Osc.ar(~w1.bufnum,freq,phase:sph.theta-sph.phi,mul:100).abs*SinOsc.ar(freq,phase:sph.theta-sph.phi)),freq*2.pow(low.lag(0.01)/992),ton.reciprocal));
	control=SinOsc.ar(freq,sph.theta-sph.phi,ton.reciprocal);


		sig = (sig+ (HPF.ar(BrownNoise.ar(noise),snare*fund)* Env.perc(0.01, 0.1).ar));

		control=SinOsc.ar(freq,sph.theta-sph.phi,ton.reciprocal);

	sig=HPF.ar(sig,50); sig=LPF.ar(sig,2000);
	sig=Compander.ar(sig,control,threshold,1,0.3,0.03,0.15);
	sig=tanh(sig*1.5);sig=Limiter.ar(sig,0.89,0.01);

	Out.ar(0, Pan2.ar(sig,anglex.round(0.0001)*mx,env));
		Out.ar(0, Pan2.ar(sig,angley.round(0.0001)*my,env));
		Out.ar(0, Pan2.ar(sig,anglez.round(0.0001)*mz,env));
}).add;
);

Synth(\snare);
////hihat
(
SynthDef(\hihat, {
	arg amp=0.1,noise=0.1,decay=1,ton=56,pan=10;
    var env,silver=pi/4,bank=21,s1,s2,s3,sig,fund=56,freq;
	var sph,anglex,angley,anglez,az,el;

freq=fund*ton;
	env= EnvGen.kr(Env.perc(0.001, decay,-8),doneAction:2,levelScale:amp);
	noise = PinkNoise.ar(env);
	sig = BPF.ar(noise, freq, 1);
	sig = HPF.ar(sig, freq);

			az=SinOsc.ar(pan,0).range(pi,pi.neg);
			el=SinOsc.ar(pan,pi/2,pan.reciprocal).range((pi/2),(pi/2).neg);

sph=Spherical(1,(az.lag(0.01)),(el.lag(0.01)));

anglex=exp(Complex(0,1)*sph.theta).real*exp(Complex(0,1)*sph.phi).real;
angley=exp(Complex(0,1)*sph.theta).imag*exp(Complex(0,1)*sph.phi).real;
anglez=exp(Complex(0,1)*sph.phi).imag;

			s1=silver-anglex; s2=silver-angley; s3=silver-anglez;

	bank.do{

		sig = sig + (sig * BrownNoise.ar(noise)); // add slight noise for punch

		Out.ar(0, Pan2.ar(sig,s1,bank.reciprocal));
		Out.ar(0, Pan2.ar(sig,s2,bank.reciprocal));
		Out.ar(0, Pan2.ar(sig,s3,bank.reciprocal));

silver=(silver+(2pi-(2pi/(1+2.sqrt)))).wrap(pi.neg,pi).round(0.00001);

	};
}).add;
);
	Synth(\hihat);
/*(
SynthDef(\ride, {
    var env,silver=45,bank=21,linex=0,liney=0,sig,noise,decay=0.2;


	env= EnvGen.kr(Env.perc(0.001, decay),doneAction:2,levelScale:1/200);
	noise = WhiteNoise.ar(env);
	sig = BPF.ar(noise, 56*128, 1);
	sig = HPF.ar(sig, 56* 128);

// ping (stick attack)
    ping = SinOsc.ar(bellFreq * 2, 0, 0.2) * env;

    // metallic wash
    wash = Mix.fill(6, {
        SinOsc.ar(exprand(2000, 9000), 0, 0.12)
    });
    wash = HPF.ar(wash, 3000);
    wash = wash * washEnv;

    // bell
    bell = SinOsc.ar(bellFreq, 0, 0.15) * Env.perc(0.001, decay * 0.6).ar;

    sig = (ping + wash + bell) * amp;

		Out.ar(0, Pan2.ar(sig,linex,bank.reciprocal));
		Out.ar(0, Pan2.ar(sig,liney,bank.reciprocal));



silver=(silver+(360-(360/(1+2.sqrt)))).wrap(180.neg,180).round(0.00001);

	};
}).add;
);
	///	Synth(\ride);

	(
SynthDef(\crash, {
    var env,silver=45,bank=21,linex=0,liney=0,sig,noise,decay=0.2;


	env= EnvGen.kr(Env.perc(0.001, decay),doneAction:2,levelScale:1/200);
	noise = WhiteNoise.ar(env);
	sig = BPF.ar(noise, 56*128, 1);
	sig = HPF.ar(sig, 56* 128);

// metallic inharmonic cluster
    metal = Mix.fill(6, { |i|
        SinOsc.ar(exprand(3000, 12000), 0, 0.15)
    });

    // noisy wash
    noise = WhiteNoise.ar(0.4);
    noise = HPF.ar(noise, 4000);

    sig = (metal + noise) * env;
    sig = sig * amp;

    sig = (ping + wash + bell) * amp;

		Out.ar(0, Pan2.ar(sig,linex,bank.reciprocal));
		Out.ar(0, Pan2.ar(sig,liney,bank.reciprocal));



silver=(silver+(360-(360/(1+2.sqrt)))).wrap(180.neg,180).round(0.00001);

	};
}).add;
);
	///	Synth(\crash);
(
SynthDef(\tom, {
	var amp=4,fund=28,ton=4,pan=0.5,low=0,noise=0.001,decay=1,equlibrium,threshold=-24.dbamp;
    var env,linex,liney,sig1,sig2,freq,angle,angle1,angle2,pos1,pos2;
	var az,el,sph1,sph2,pan1,pan2,phase1,phase2,p_amp1=1,p_amp2=1,control;

	freq = EnvGen.kr(Env([fund*ton, fund], [decay/8], curve: -4)); // pitch drop
	env= EnvGen.kr(Env.perc(0.01, decay, curve: -4),doneAction:2,levelScale:amp);

equlibrium=pi;
phase1=0.degrad; phase2=(equlibrium-90.degrad).wrap2(pi);
pan1=SinOsc.ar(pan*3,phase:phase1,mul:p_amp1);
pan2=SinOsc.ar(pan*2,phase:phase2,mul:p_amp2);

	az=SinOsc.ar(1,0.degrad,pi);
	el=SinOsc.ar(1,90.degrad,pi/2);


sph1=Spherical(1,(az),(el));
sph2=Spherical(1,(az),(el+equlibrium).wrap2((pi/2)));

angle1=Complex(exp(Complex(0,1)*sph1.theta).real,exp(Complex(0,1)*sph1.phi).imag).theta;
angle2=Complex(exp(Complex(0,1)*sph2.theta).real,exp(Complex(0,1)*sph2.phi).imag).theta;

angle=Complex(exp(Complex(0,1)*angle1).real,exp(Complex(0,1)*angle2).imag).theta;

pos1=exp(Complex(0,1)*angle).real;
pos2=exp(Complex(0,1)*angle).imag;

//linex=exp(Complex(0,1)*pan.degrad).real.round(0.00001).abs;
//liney=exp(Complex(0,1)*pan.degrad).real.round(0.00001).abs.neg;
//phase=pan.degrad;

		sig1=(LPF.ar((Osc.ar(~w1.bufnum,freq,phase:phase1,mul:100).abs*SinOsc.ar(freq,phase:phase1)),freq*2.pow(low.lag(0.01)/992)));
        sig2=(LPF.ar((Osc.ar(~w1.bufnum,freq,phase:phase2,mul:100).abs*SinOsc.ar(freq,phase:phase2)),freq*2.pow(low.lag(0.01)/992)));
	control=SinOsc.ar(freq,angle);


sig1 = sig1 + (sig1 * (BPF.ar(BrownNoise.ar(noise),freq*2)* Env.perc(0.001, 0.05).ar));
sig2 = sig2 + (sig2 * (BPF.ar(BrownNoise.ar(noise),freq*2)* Env.perc(0.001, 0.05).ar));

	Delay1.ar(in: 0.0, mul: 1.0, add: 0.0, x1: 0.0)

		sig2=HPF.ar(sig2,50); sig2=LPF.ar(sig2, 2000); sig1=HPF.ar(sig1,50); sig1=LPF.ar(sig1, 2000);
		sig2=Compander.ar(sig2,control,threshold,1,0.3,0.015,0.3); sig1=Compander.ar(sig1,control,threshold,1,0.3,0.015,0.3);
		sig1=tanh(sig1*2);sig2=tanh(sig2*2);sig1=Limiter.ar(sig1,1,0.01);sig2=Limiter.ar(sig2,1,0.01);


		Out.ar(0, Pan2.ar(sig1,pos1,env)*pan1);
		Out.ar(0, Pan2.ar(sig2,pos2,env)*pan2);

}).add;);
	///	Synth(\tom);

// Test it:
Synth(\hihat);
Synth(\snare);
Synth(\kick);
)*/

	/////solid
(
~az=[0.degrad,0.degrad,90.degrad,180.degrad,90.neg.degrad,0.degrad];
~el=[90.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,90.degrad];
);
//////////patterns

	({var m1=1.neg, m2=1.neg, m3=1.neg,a,b,c, beat=1, frame=32.reciprocal,n=0,bank=6;

		~durk=[];~durs=[];~durh=[];

~x=bank.collect{
m1=m1+1;
	b=Spherical(beat,~az.[m1],~el.[m1]).rotate(0.degrad).x.round(frame);
	2.pow(b).round(0.00001);
};
~y=bank.collect{
m2=m2+1;
	c=Spherical(beat,~az.[m2],~el.[m2]).rotate(0.degrad).y.round(frame);
	2.pow(c).round(0.00001);
};
~z=bank.collect{
m3=m3+1;
	d=Spherical(beat,~az.[m3],~el.[m3]).rotate(0.degrad).z.round(frame);
	2.pow(d).round(0.00001);
};
		bank.do{ ~durk=~durk++~x.[n];n=n+1;};n=0;
		bank.do{ ~durs=~durs++~y.[n];n=n+1;};n=0;
		bank.do{ ~durh=~durh++~z.[n];n=n+1;};n=0;
	//	bank.do{~durs=~durs++~x.[n]++~y.[n]++~z.[n];n=n+1;}
//	~dur = ~duri.collect { |x|
  //  if (x == 0) { Rest(2) } { x }
//	}
}.value;
)
(
	(
		~kick=Pdef(\1, Pbind(\instrument, \kick,
			\dur,Pseq(~durk,inf),
		))
);

(
		~snare=Pdef(\2, Pbind(\instrument, \snare,
			\dur,Pseq(~durs,inf),
		))
);
(
		~hihat=Pdef(\3, Pbind(\instrument, \hihat,
			\dur,Pseq(~durh,inf),
		))
);
		/*(
		~ride=Pdef(\4, Pbind(\instrument, \ride,
			\dur,Pseq(~dur,inf),
		))
);*/
/*(
		~crash=Pdef(\5, Pbind(\instrument, \crash,
			\dur,Pseq(~dur,inf),
		))
);*/
		/*(
		~tom=Pdef(\6, Pbind(\instrument, \tom,
			\dur,Pseq(~dur,inf),
		))
);*/


);




TempoClock.default.tempo_(4);

(
~kick.play;
~snare.play;
//~hihat.play;
//~ride.play;
//~crash.play;
//~tom.play;
//~kick.pause;
//~snare.pause;
//~hihat.pause;
//~ride.pause;
//~crash.pause;
//~tom.pause;
)
}))


(
r = Routine {
	loop{ 4.do{ 10.rand.postln; 1.wait;};
		1.wait;
};

}
);

r.play

	///tetrahedron
(
~az=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
//////cube
(
~az=[45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];
)

/////octahedron

(
~az=[0.degrad,0.degrad,90.degrad,180.degrad,90.neg.degrad,0.degrad];
~el=[90.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,90.degrad];
)

//////icosahedron
(
~az=[90.degrad,90.neg.degrad,0.degrad,180.degrad,58.28.degrad,121.72.degrad,121.72.neg.degrad,58.neg.degrad,90.degrad,90.neg.degrad,0.degrad,180.degrad];
~el=[58.28.neg.degrad,58.28.neg.degrad,31.72.neg.degrad,31.72.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,58.28.degrad,58.28.degrad,31.72.degrad,31.72.degrad];
)

/////dodecahedron

(
~az=[45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,90.degrad,90.neg.degrad,0.degrad,180.degrad,45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,90.degrad,
	90.neg.degrad,69.09.degrad,110.91.degrad,110.91.neg.degrad,69.09.neg.degrad,0.degrad,180.degrad];

~el=[35.26.neg.degrad,35.26.neg.degrad,35.26.neg.degrad,35.26.neg.degrad,69.09.neg.degrad,69.09.neg.degrad,20.91.neg.degrad,20.91.neg.degrad,
	35.26.degrad,35.26.degrad,35.26.degrad,35.26.degrad,69.09.degrad,69.09.degrad,0.degrad,0.degrad,0.degrad,0.degrad,20.91.degrad,20.91.degrad]
)

/////Rhombic dodecahedron//// hull

(
~az=[0.degrad,45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,0.degrad,180.degrad,90.degrad,90.neg.degrad,0.degrad,
	45.degrad,135.neg.degrad,135.degrad,45.neg.degrad];
~el=[90.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,0.degrad
	,0.degrad,0.degrad,0.degrad,90.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];
)

/////cuboctahedron//// core

(
~az=[0.degrad,90.degrad,180.degrad,90.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,
	0.degrad,90.degrad,180.degrad,90.neg.degrad];
~el=[45.neg.degrad,45.neg.degrad,45.neg.degrad,45.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,
	45.degrad,45.degrad,45.degrad,45.degrad];
)


///////////////Rhombic Triacontahedron//// hull
(
~az=[0.degrad,0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,
	0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,
	0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,0.degrad];

~el=[90.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,52.6.degrad,52.6.degrad,52.6.degrad,52.6.degrad,52.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,10.8.degrad,10.8.degrad,10.8.degrad,10.8.degrad,10.8.degrad,90.degrad];

)

///////icosidodecahedron//// core
(
~az=[18.degrad,90.degrad,162.degrad,126.neg.degrad,54.neg.degrad,54.degrad,126.degrad,162.neg.degrad,90.neg.degrad,18.neg.degrad,
	0.degrad,36.degrad,72.degrad,108.degrad,144.degrad,180.degrad,144.neg.degrad,108.neg.degrad,72.neg.degrad,36.neg.degrad,
	54.degrad,126.degrad,162.neg.degrad,90.neg.degrad,18.neg.degrad,18.degrad,90.degrad,162.degrad,126.neg.degrad,54.neg.degrad];

~el=[58.283.degrad,58.283.degrad,58.283.degrad,58.283.degrad,58.283.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,
37.717.degrad,37.717.degrad,37.717.degrad,37.717.degrad,37.717.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad];

)