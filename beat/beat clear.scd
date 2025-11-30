(
//s.options.numWireBufs = 1024*2;s.options.memSize = 8192*8;s.options.blockSize = 64;
s.options.numOutputBusChannels=2;s.options.numInputBusChannels=0;
//s.options.maxNodes = 1024 * 16;
//s.options.sampleRate= 44100;
//s.recChannels = 4;s.recHeaderFormat="aiff";s.recSampleFormat ="int16";
s.boot;
)

(
/////tetrahedron
(
~az1=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el1=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);

/////tetrahedron
(
~az2=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el2=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);

//////tetrahedron
(
~az3=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el3=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
)
/*(

/////tetrahedron
(
~az1=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el1=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
/////octahedron
(
~az2=[0.degrad,0.degrad,90.degrad,180.degrad,90.neg.degrad,0.degrad];
~el2=[90.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,90.degrad];
);

//////cube
(
~az3=[45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad];
~el3=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];
);
/////ico
(
~az4=[90.degrad,90.neg.degrad,0.degrad,180.degrad,58.28.degrad,121.72.degrad,121.72.neg.degrad,58.neg.degrad,90.degrad,90.neg.degrad,0.degrad,180.degrad];
~el4=[58.28.neg.degrad,58.28.neg.degrad,31.72.neg.degrad,31.72.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,58.28.degrad,58.28.degrad,31.72.degrad,31.72.degrad];
)
)*/

////beat matrix
(
var plm1=0,plm2=0,plm3=0;
var tetrahedron=4,octahedron=6,cube=8,dur_mul=1;
var plx1=1.neg,ply1=1.neg,plz1=1.neg;
var plx2=1.neg,ply2=1.neg,plz2=1.neg;
var plx3=1.neg,ply3=1.neg,plz3=1.neg;
var angle_a=30/2,angle_b=60/2,angle_c=120/2;
var axis_xyz=[1,0,0].normalizeSum.sqrt,axis;
var i=Quaternion(0, axis_xyz.[0], 0, 0),j=Quaternion(0, 0, axis_xyz.[1], 0),k=Quaternion(0, 0, 0, axis_xyz.[2]);
var qx1,qy1,qz1,qx2,qy2,qz2,qx3,qy3,qz3;
var rotor_a,rotor_b,rotor_c;
var ax,ay,az,bx,by,bz,cx,cy,cz;

~dur_a=[];~dur_b=[];~dur_c=[];
axis=i+j+k;
dur_mul.do{
~x1=tetrahedron.collect{
	plx1=plx1+1;
	qx1=Quaternion(0,Spherical(1,~az1[plx1],~el1[plx1]).x.round(0.00001),Spherical(1,~az1[plx1],~el1[plx1]).y.round(0.00001),Spherical(1,~az1[plx1],~el1[plx1]).z.round(0.00001));
	rotor_a=((axis*exp(Complex(0,1)*angle_a.degrad).imag)+exp(Complex(0,1)*angle_a.degrad).real); ax=rotor_a*qx1*rotor_a.conjugate;
	ax.b.round(0.00001);
};
~y1=tetrahedron.collect{
	ply1=ply1+1;
	qy1=Quaternion(0,Spherical(1,~az1[ply1],~el1[ply1]).x.round(0.00001),Spherical(1,~az1[ply1],~el1[ply1]).y.round(0.00001),Spherical(1,~az1[ply1],~el1[ply1]).z.round(0.00001));
	rotor_a=((axis*exp(Complex(0,1)*angle_a.degrad).imag)+exp(Complex(0,1)*angle_a.degrad).real); ay=rotor_a*qy1*rotor_a.conjugate;
	ay.c.round(0.00001);
};
~z1=tetrahedron.collect{
	plz1=plz1+1;
	qz1=Quaternion(0,Spherical(1,~az1[plz1],~el1[plz1]).x.round(0.00001),Spherical(1,~az1[plz1],~el1[plz1]).y.round(0.00001),Spherical(1,~az1[plz1],~el1[plz1]).z.round(0.00001));
	rotor_a=((axis*exp(Complex(0,1)*angle_a.degrad).imag)+exp(Complex(0,1)*angle_a.degrad).real); az=rotor_a*qz1*rotor_a.conjugate;
	az.d.round(0.00001);
};
~x2=tetrahedron.collect{
	plx2=plx2+1;
	qx2=Quaternion(0,Spherical(1,~az2[plx2],~el2[plx2]).x.round(0.00001),Spherical(1,~az2[plx2],~el2[plx2]).y.round(0.00001),Spherical(1,~az2[plx2],~el2[plx2]).z.round(0.00001));
	rotor_b=((axis*exp(Complex(0,1)*angle_b.degrad).imag)+exp(Complex(0,1)*angle_b.degrad).real); bx=rotor_b*qx2*rotor_b.conjugate;
	bx.b.round(0.00001);
};
~y2=tetrahedron.collect{
	ply2=ply2+1;
	qy2=Quaternion(0,Spherical(1,~az2[ply2],~el2[ply2]).x.round(0.00001),Spherical(1,~az2[ply2],~el2[ply2]).y.round(0.00001),Spherical(1,~az2[ply2],~el2[ply2]).z.round(0.00001));
	rotor_b=((axis*exp(Complex(0,1)*angle_b.degrad).imag)+exp(Complex(0,1)*angle_b.degrad).real); by=rotor_b*qy2*rotor_b.conjugate;
	by.c.round(0.00001);
};
~z2=tetrahedron.collect{
	plz2=plz2+1;
	qz2=Quaternion(0,Spherical(1,~az2[plz2],~el2[plz2]).x.round(0.00001),Spherical(1,~az2[plz2],~el2[plz2]).y.round(0.00001),Spherical(1,~az2[plz2],~el2[plz2]).z.round(0.00001));
	rotor_b=((axis*exp(Complex(0,1)*angle_b.degrad).imag)+exp(Complex(0,1)*angle_b.degrad).real); bz=rotor_b*qz2*rotor_b.conjugate;
	bz.d.round(0.00001);
};
~x3=tetrahedron.collect{
	plx3=plx3+1;
	qx3=Quaternion(0,Spherical(1,~az3[plx3],~el3[plx3]).x.round(0.00001),Spherical(1,~az3[plx3],~el3[plx3]).y.round(0.00001),Spherical(1,~az3[plx3],~el3[plx3]).z.round(0.00001));
	rotor_c=((axis*exp(Complex(0,1)*angle_c.degrad).imag)+exp(Complex(0,1)*angle_c.degrad).real); cx=rotor_c*qx3*rotor_c.conjugate;
	cx.b.round(0.00001);
};
~y3=tetrahedron.collect{
	ply3=ply3+1;
	qy3=Quaternion(0,Spherical(1,~az3[ply3],~el3[ply3]).x.round(0.00001),Spherical(1,~az3[ply3],~el3[ply3]).y.round(0.00001),Spherical(1,~az3[ply3],~el3[ply3]).z.round(0.00001));
	rotor_c=((axis*exp(Complex(0,1)*angle_c.degrad).imag)+exp(Complex(0,1)*angle_c.degrad).real); cy=rotor_c*qy3*rotor_c.conjugate;
	cy.c.round(0.00001);
};
~z3=tetrahedron.collect{
	plz3=plz3+1;
	qz3=Quaternion(0,Spherical(1,~az3[plz3],~el3[plz3]).x.round(0.00001),Spherical(1,~az3[plz3],~el3[plz3]).y.round(0.00001),Spherical(1,~az3[plz3],~el3[plz3]).z.round(0.00001));
	rotor_c=((axis*exp(Complex(0,1)*angle_c.degrad).imag)+exp(Complex(0,1)*angle_c.degrad).real); cz=rotor_c*qz3*rotor_c.conjugate;
	cz.d.round(0.00001);
};

tetrahedron.do{ ~dur_a=~dur_a++~x1.[plm1]++~y1.[plm1]++~z1.[plm1]; plm1=plm1+1;};
tetrahedron.do{ ~dur_b=~dur_b++~x2.[plm2]++~y2.[plm2]++~z3.[plm2]; plm2=plm2+1;};
tetrahedron.do{ ~dur_c=~dur_c++~x3.[plm3]++~y3.[plm3]++~z3.[plm3]; plm3=plm3+1;};

//angle_a=(angle_a+(360-(360/((1+5.sqrt)/2)))).wrap(180.neg,180).round(0.0001);
//angle_b=(angle_b+(360-(360/((1+5.sqrt)/2)))).wrap(180.neg,180).round(0.0001);
//angle_c=(angle_c+(360-(360/((1+5.sqrt)/2)))).wrap(180.neg,180).round(0.0001);

//angle_a=(angle_a+30).wrap(0,360).round(0.0001);
//angle_b=(angle_b+30).wrap(0,360).round(0.0001);
//angle_c=(angle_c+30).wrap(0,360).round(0.0001);

//angle_a=360/7;
//angle_b=360/7;
//angle_c=360/7;

	axis_xyz=[0,0,1].normalizeSum.sqrt;
	 i=Quaternion(0, axis_xyz.[0], 0, 0);
	j=Quaternion(0, 0, axis_xyz.[1], 0);
	k=Quaternion(0, 0, 0, axis_xyz.[2]);
	axis=i+j+k;

plx1=1.neg;ply1=1.neg;plz1=1.neg;
plx2=1.neg;ply2=1.neg;plz2=1.neg;
plx3=1.neg;ply3=1.neg;plz3=1.neg;
plm1=0;plm2=0;plm3=0;
};

~dur_a=~dur_a.abs;~dur_b=~dur_b.abs;~dur_c=~dur_c.abs;

~dur1= ~dur_a.collect { |d| if (d == 0) { Rest(0.57735) } { d } };
~dur2= ~dur_b.collect { |d| if (d == 0) { Rest(0.57735) } { d } };
~dur3= ~dur_c.collect { |d| if (d == 0) { Rest(0.57735) } { d } };
)


(
//////kick
(
SynthDef(\kick, {
    var env,silver=45,bank=9,linex=0,liney=0,sig;
	var phs,golden=90,ton=2,freq,decay=2;

	freq = EnvGen.kr(Env([56*ton, 28],  [0.5], curve: -4)); // pitch drop
	env= EnvGen.kr(Env.perc(0.01, decay, curve: -4),doneAction:2,levelScale:1/4);
	//sig = SinOsc.ar(freq,freq/56) * env;

	bank.do{

linex=exp(Complex(0,1)*silver.degrad).real.round(0.00001).abs;
liney=exp(Complex(0,1)*silver.degrad).imag.round(0.00001).abs.neg;
phs=golden.degrad;

		sig=(LPF.ar(Pulse.ar((freq),width:0.5,mul:freq/56).abs,56*4)*SinOsc.ar(freq/2,phs,freq/56))*env;

sig = sig + (sig * BrownNoise.ar(0.0001)); // add slight noise for punch

		Out.ar(0, Pan2.ar(sig,linex));
		Out.ar(0, Pan2.ar(sig,liney));

silver=(silver+(360-(360/(1+2.sqrt)))).wrap(180.neg,180).round(0.00001);
golden=(golden+(360-(360/((1+5.sqrt)/2)))).wrap(180.neg,180).round(0.0001);

	};
}).add;
);
//Synth(\kick);
/////snare
(
SynthDef(\snare, {
    var env,silver=45,golden=90,bank=9,linex=0,liney=0,sig,phs;
	var toneEnv,tone,noise,ton=3,decay=2;

	toneEnv = EnvGen.kr(Env.perc(0.0001, decay));
	env= EnvGen.kr(Env.perc(0.0001, decay),doneAction:2,levelScale:1/16);
	noise= BrownNoise.ar(0.01)*env;

	bank.do{


linex=exp(Complex(0,1)*silver.degrad).real.round(0.00001).abs;
liney=exp(Complex(0,1)*silver.degrad).imag.round(0.00001).abs.neg;
phs=golden.degrad;

		tone=LPF.ar(Pulse.ar((56*ton),width:0.5,mul:toneEnv).abs,56*16)*SinOsc.ar((56*ton)/2,phs,toneEnv);
		sig = (tone * 0.1) + (noise * 0.5);
	    sig = HPF.ar(sig, 56); // filter out low rumble

		Out.ar(0, Pan2.ar(sig,linex));
		Out.ar(0, Pan2.ar(sig,liney));

silver=(silver+(360-(360/(1+2.sqrt)))).wrap(180.neg,180).round(0.00001);
golden=(golden+(360-(360/((1+5.sqrt)/2)))).wrap(180.neg,180).round(0.0001);

	};
}).add;
);

//Synth(\snare);
////hihat
(
SynthDef(\hihat, {
    var env,silver=45,bank=21,linex=0,liney=0,sig,noise,decay=0.2;


	env= EnvGen.kr(Env.perc(0.001, decay),doneAction:2,levelScale:1/200);
	noise = WhiteNoise.ar(env);
	sig = BPF.ar(noise, 56*128, 1);
	sig = HPF.ar(sig, 56* 128);

	bank.do{

linex=exp(Complex(0,1)*silver.degrad).real.round(0.00001).abs;
liney=exp(Complex(0,1)*silver.degrad).imag.round(0.00001).abs.neg;

		sig = sig + (sig * bank.reciprocal * BrownNoise.ar(0.01)); // add slight noise for punch

		Out.ar(0, Pan2.ar(sig,linex,bank.reciprocal));
		Out.ar(0, Pan2.ar(sig,liney,bank.reciprocal));

silver=(silver+(360-(360/(1+2.sqrt)))).wrap(180.neg,180).round(0.00001);

	};
}).add;
)
)

// Test it:
Synth(\hihat);
Synth(\snare);
Synth(\kick);

//////////patterns
(
	(
		~kick=Pdef(\1, Pbind(\instrument, \kick,
			\dur,Pseq(~dur1,inf),
		))
);

(
		~snare=Pdef(\2, Pbind(\instrument, \snare,
			\dur,Pseq(~dur1.reverse,inf),
		))
);
(
		~hihat=Pdef(\3, Pbind(\instrument, \hihat,
			\dur,Pseq(~dur1.reverse/4,inf),
		))
)
)



TempoClock.default.tempo_(120/152);

(
~kick.play;
~snare.play;
~hihat.play;
~kick.pause;
~snare.pause;
~hihat.pause;
)
)


(
Buffer.freeAll;

~c1 = Buffer.readChannel(s,
	,channels:0);
~c2 = Buffer.readChannel(s,
	,channels:1);
)




(
{Out.ar(0,PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1.bufnum), loop: 0, doneAction:2)*0.5)}.play;
{Out.ar(1,PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2.bufnum), loop: 0, doneAction:2)*0.5)}.play;
(
~kick.play;
~snare.play;
~hihat.play;
//~kick.pause;
//~snare.pause;
s.record(duration:((3*60)+43)*2);
)
)
(
//~snare.play;
~kick.pause;
~snare.pause;
~hihat.pause;
)
)




(
Synth(\o_reverb,[\amp,1]);
//s.record(duration:(16*60));
)
(
SynthDef.new(\o_reverb, {

	arg amp+1;
    var in1,in2,chaina,chainb,chainxx,chainyy,chainaa,chainbb;
	var frames+1024,sig1,sig2,silver=45,golden=45,l,r,phs=0,n=0;


    in1 = PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1.bufnum), loop: 0, doneAction:0);
	in2 = PlayBuf.ar(1, ~c2.bufnum, BufRateScale.kr(~c2.bufnum), loop: 0, doneAction:0);


	chaina = FFT(LocalBuf(frames), in1);
	chainb = FFT(LocalBuf(frames), in2);

	256.do{

chainaa = chaina.pvcollect(frames,
			{|mag, phase, index| [mag, (phase)]; }, frombin: n, tobin: n, zeroothers: 1);
chainbb = chainb.pvcollect(frames,
			{|mag, phase, index| [mag, (phase+135.degrad)]; }, frombin: n, tobin: n, zeroothers: 1);


l=exp(Complex(0,1)*golden.degrad).real.round(0.0001).abs;
r=exp(Complex(0,1)*golden.degrad).imag.round(0.0001).abs.neg;

				silver=(silver+(360-(360/(1+2.sqrt)))).wrap(180.neg,180).round(0.0001);
		golden=(golden+(360-(360/((1+5.sqrt)/2)))).wrap(180.neg,180).round(0.0001);

//phs=golden.degrad;

n=n+1;

sig1=IFFT(chainaa);
sig2=IFFT(chainbb);

Out.ar(0,Pan2.ar(sig1,l,amp));
Out.ar(0,Pan2.ar(sig2,r,amp));

	};
}).add;
)








