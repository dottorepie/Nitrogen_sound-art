/////////rhythm design visualizer
(
var data;
var az=0,el=0;
var m=600,sph,az1,el1,pl2=0,daz,del,harm,mag,r;
var r1,harm1,r2,harm2,rad;
var run = true,n=12;
var ot=0.degrad,mk=0,size=2.sqrt+100;

data = (4).collect{

	az=~az.[pl2];
	el=~el.[pl2];

	pl2=pl2+1;

		sph=Spherical(1000,az,el).asCartesian.asArray;
};

w = Window.new("3D Scatterplot", Rect(40,40, 800, 800)).front;

~v = UserView.new(w,Rect(0,0,800,800)).background_(Color.black);
a = ScatterView3d(~v, Rect(0,0, 800,800), data, [-1000, 1000].asSpec,[-1000, 1000].asSpec,[-1000, 1000].asSpec);
a.drawMethod = \fillRect;
a.symbolSize = 10;
a.symbolColor = Color.white;
a.background = Color.black;

~v.animate;
~v.drawFunc ={
Pen.translate(400,400);

		a.rot(ot,ot,ot);
    ~v.refresh;

		ot=ot+0.05.degrad;

};
{ while { run } {~v.background_(Color.black); ~v.refresh; (1/1000).wait } }.fork(AppClock);
)


/////tetrahedron

(
~az=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];

)


//////rhythm tests

////Τετραεδρο ως control array του Ρυθμού. Μέτρο xyz. Με εναλλαγές στους χρόνους λόγο περιστροφής τετραεδρου σε γεοδεσικο πλαίσιο.
///Test models of rhythm (synthdef pattern)
///In control array rhytm file.  eg Cartsian tetrahedron xyz is 3/4 σε 4 μέτρα {χωρίς περιστροφή, μισή περίοδος (ολόκληρη περίοδος είναι δύο μέτρα)}, τετραδονιο τετραεδρο qxyz είναι 4/4 σε 4 μέτρα.

//////cartesian 3/4 rhythm τετράεδρο μέτρο
(
var pl=0,plx=1.neg,ply=1.neg,plz=1.neg;~dur1=[];

~x=4.collect{
	plx=plx=1;
	(Spherical(1,~az[plx],~el[plx]).rotate(0.degrad).tilt(0.degrad).tumble(0.degrad)).x.round(0.000001);	};
~y=4.collect{
	ply=ply=1;
	(Spherical(1,~az[ply],~el[ply]).rotate(0.degrad).tilt(0.degrad).tumble(0.degrad)).y.round(0.000001);	};
~z=4.collect{
	plz=plz=1;
	(Spherical(1,~az[plz],~el[plz]).rotate(0.degrad).tilt(0.degrad).tumble(0.degrad)).z.round(0.000001);	};

4.do{ ~dur=~dur++~x.[pl]++~y.[pl]++~z.[pl]; pl=pl+1;};

~dur1=~dur1.abs
)

//////synth example

(
SynthDef(\kick, {
    var env,silver=45,bank=8,linex=0,liney=0,sig;
    var freq = Env([56*2, 56], [0.3], curve: -8).kr; // pitch drop

	env= EnvGen.kr(Env.perc(0.01, 1, curve: -4),doneAction:2);
	sig = SinOsc.ar(freq) * env;

	bank.do{

linex=exp(Complex(0,1)*silver.degrad).real.round(0.0001).abs;
liney=exp(Complex(0,1)*silver.degrad).imag.round(0.0001).abs.neg;

		sig = sig + (sig * bank.reciprocal * BrownNoise.ar(0.001)); // add slight noise for punch

		Out.ar(0, Pan2.ar(sig,linex,0.05));
		Out.ar(0, Pan2.ar(sig,liney,0.05));

silver=(silver+(360-(360/(1+2.sqrt)))).wrap(180.neg,180).round(0.0001);

	};
}).add;
)

//////////pattern
	(
		~rha=Pdef(\1, Pbind(\instrument, \kick,
			\dur,Pseq(~dur,inf),
	//\tone_signature,Pseq(~dur,inf);
		))
);



TempoClock.default.tempo_(0.9);


~rha.play;
//


/////xyz metro can be used for dur of pattern and quaternion with 4 metro including the value of 0 can be used as amp argument for the synth envelope like L-system from previous examples. Musicaly this indicates the time or presence(amp) signature of each note and pauses etc.


/////quaternion 4/4 rhythm τετράεδρο μέτρο

//////////////////////with angle as argument, (along with Quaternion file
	//axis=i+j+k;
//////q1=((axis*exp(Complex(0,1)*angle).imag)+exp(Complex(0,1)*angle).real); v1=q1*v1*q1.conjugate;

///////////use distance .distance between quaternions pl1 points as some kind of modulation
// (
// var q1,q2,dist;
// q1=Quaternion(0,1,1,1); q2=Quaternion(0,0,0,0);
// dist=q1.distance(q2);
// dist.postln;)*/
//
// (
// var pl=0,plq=1.neg,pli=1.neg,plj=1.neg,plk=1.neg,i,j,k,axis,r,angle=30; ~dur=[];
//
// axis=[0,0,1].normalizeSum.sqrt;
// i=Quaternion(0, axis.[0], 0, 0);
// j=Quaternion(0, 0, axis.[1], 0);
// k=Quaternion(0, 0, 0, axis.[2]);
// r=(cos(angle.degrad)+(sin(angle.degrad)*(i+j+k)));
//
// ~q=4.collect{
// 	plq=plq=1;
// (r*Quaternion(0,Spherical(1,~az[plq],~el[plq]).x,Spherical(1,~az[plq],~el[plq]).y,Spherical(1,~az[plq],~el[plq]).z)).a.round(0.000001);	};
// ~i=4.collect{
// 	pli=pli=1;
// (r*Quaternion(0,Spherical(1,~az[pli],~el[pli]).x,Spherical(1,~az[pli],~el[pli]).y,Spherical(1,~az[pli],~el[pli]).z)).b.round(0.000001);	};
// ~j=4.collect{
// 	plj=plj=1;
// (r*Quaternion(0,Spherical(1,~az[plj],~el[plj]).x,Spherical(1,~az[plj],~el[plj]).y,Spherical(1,~az[plj],~el[plj]).z)).c.round(0.000001);	};
// ~k=4.collect{
// 	plk=plk=1;
// (r*Quaternion(0,Spherical(1,~az[plk],~el[plk]).x,Spherical(1,~az[plk],~el[plk]).y,Spherical(1,~az[plk],~el[plk]).z)).d.round(0.000001);	};
//
// 4.do{ ~dur=~dur++~q.[pl]++~i.[pl]++~j.[pl]++~k.[pl]; pl=pl+1;};
//
// ~dur=~dur.abs
// )




///two tetrahdra imaginary cube, two parallel rhythm lines (polyrhythm)
(
var plm1=0,plm2=0,plx1=1.neg,ply1=1.neg,plz1=1.neg,plx2=1.neg,ply2=1.neg,plz2=1.neg,angle_a=0,angle_b=90,angle_c=45,angle_d=45;~dur_a=[];~dur_b=[];

~x1=4.collect{
	plx1=plx1=1;
	Spherical(1,~az[plx1],~el[plx1]).rotate(angle_a.degrad).tilt(angle_d.degrad).tumble(angle_c.degrad).x.round(0.0001);	};
~y1=3.collect{
	ply1=ply1=1;
	Spherical(1,~az[ply1],~el[ply1]).rotate(angle_a.degrad).tilt(angle_d.degrad).tumble(angle_c.degrad).y.round(0.0001);	};
~z1=4.collect{
	plz1=plz1=1;
	Spherical(1,~az[plz1],~el[plz1]).rotate(angle_a.degrad).tilt(angle_d.degrad).tumble(angle_c.degrad).z.round(0.0001);	};
~x2=4.collect{
	plx2=plx2=1;
	Spherical(1,~az[plx2],~el[plx2]).rotate(angle_b.degrad).tilt(angle_d.degrad).tumble(angle_c.degrad).x.round(0.0001);	};
~y2=4.collect{
	ply2=ply2=1;
	Spherical(1,~az[ply2],~el[ply2]).rotate(angle_b.degrad).tilt(angle_d.degrad).tumble(angle_c.degrad).y.round(0.0001);	};
~z2=4.collect{
	plz2=plz2=1;
	Spherical(1,~az[plz2],~el[plz2]).rotate(angle_b.degrad).tilt(angle_d.degrad).tumble(angle_c.degrad).y.round(0.0001);	};

4.do{ ~dur_a=~dur_a++~x1.[plm1]++~y1.[plm1]++~z1.[plm1]; plm1=plm1+1;};
4.do{ ~dur_b=~dur_b++~x2.[plm2]++~y2.[plm2]++~z2.[plm2]; plm2=plm2+1;};

~dur_a=~dur_a.abs;~dur_b=~dur_b.abs;
)

//////synth example

(
SynthDef.new(\R, {
	arg tone_signature=1;
var env,sig,envfreq;
	env=EnvGen.ar(Env.perc(0.01,0.5,tone_signature));
	envfreq=EnvGen.ar(Env([56,56*2.28],[0.01,0.5,0.01],tone_signature));
	sig=LPF.ar(Saw.ar(envfreq,env),56*4);
	Out.ar([0,1],sig);

}).add;
)

//////////pattern
(
	(
		~rha=Pdef(\1, Pbind(\instrument, \R,
			\dur,Pseq(~dur_a,inf),
	\tone_signature,Pseq(~dur_a,inf);
		))
);

(
		~rhb=Pdef(\2, Pbind(\instrument, \R,
			\dur,Pseq(~dur_b,inf),
	\tone_signature,Pseq(~dur_b,inf);
		))
)
)

TempoClock.default.tempo_(2);


~rha.play;~rhb.play;

///quaternial rotaion
/*v=Quaternion(0,sph.x,sph.y,sph.z);/// vector as quaternion

	coordinates=[1,0,0].normalizeSum.sqrt;

i=Quaternion(0, coordinatesx.[0], 0, 0);
j=Quaternion(0, 0, coordinatesx.[1], 0);
k=Quaternion(0, 0, 0, coordinatesx.[2]);

axis=(((i+j+k)*exp(Complex(0,1)*rot_angle).imag)+exp(Complex(0,1)*rot_angle).real); ////rotation vector with angle of rotatio and ijk xyz normalized components
v1=axis*v*axis.conjugate;*/


////core rhythm two tetrahedra cube, core octahedron 18/4 eg 9/8

(

~azokt=[0.degrad,0.degrad,90.degrad,180.degrad,90.neg.degrad,0.degrad];
~elokt=[90.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,90.degrad];

)


(
var pl=0,plx=1.neg,ply=1.neg,plz=1.neg;~dur=[];

~x=6.collect{
	plx=plx=1;
	Spherical(1,~azokt[plx],~elokt[plx]).rotate(45.degrad).tilt(45.degrad).tumble(0.degrad).x.round(0.0001);	};
~y=6.collect{
	ply=ply=1;
	Spherical(1,~azokt[ply],~elokt[ply]).rotate(45.degrad).tilt(45.degrad).tumble(0.degrad).y.round(0.0001);	};
~z=6.collect{
	plz=plz=1;
	Spherical(1,~azokt[plz],~elokt[plz]).rotate(45.degrad).tilt(45.degrad).tumble(0.degrad).z.round(0.0001);	};

6.do{ ~dur=~dur++~x.[pl]++~y.[pl]++~z.[pl]; pl=pl+1;};

~dur=~dur.abs
)


//////synth example

(
SynthDef.new(\R, {
	arg tone_signature=1;
var env,sig,envfreq;
	env=EnvGen.ar(Env.perc(0.01,0.4,tone_signature),doneAction:2);
	envfreq=EnvGen.ar(Env([56,56*2],[0.01,0.4],tone_signature));
	sig=LPF.ar(Saw.ar(envfreq,env),56*4);
	Out.ar([0,1],sig);

}).add;
)

//////////pattern

	(
		~rh=Pdef(\1, Pbind(\instrument, \R,
			\dur,Pseq(~dur,inf),
	\tone_signature,Pseq(~dur,inf);
		))
)



TempoClock.default.tempo_(1);


~rh.play;

//////////drum sounds sc master chatgpt

(
SynthDef(\kick, {
    var env = Env.perc(0.01, 1, curve: -4).kr;
    var freq = Env([100, 40], [0.3], curve: -4).kr; // pitch drop
    var sig = SinOsc.ar(freq) * env;
	sig = sig + (sig * 0.2 * WhiteNoise.ar(0.01)); // add slight noise for punch
    Out.ar(0, sig.dup * 0.8);
}).add;
)

// Test it:
Synth(\kick);


(
SynthDef(\snare, {
    var env = Env.perc(0.01, 0.25).kr;
    var toneEnv = Env.perc(0.000001, 0.2).kr;
    var tone = SinOsc.ar(180, 0, toneEnv); // body
	var noise = WhiteNoise.ar(0.1) * env; // snappy noise
    var sig = (tone * 0.3) + (noise * 0.7);
    sig = HPF.ar(sig, 200); // filter out low rumble
    Out.ar(0, sig.dup * 0.8);
}).add;
)

// Test it:
Synth(\snare);


(
SynthDef(\hihat, {
    var env = Env.perc(0.000001, 0.08).kr;
    var noise = WhiteNoise.ar * env;
    var sig = BPF.ar(noise, 8000, 0.5); // bright filter
    sig = HPF.ar(sig, 5000); // remove lows
    Out.ar(0, sig.dup * 0.6);
}).add;
)

// Test it:
Synth(\hihat);



///////////////////////////control array _ roataion axis points_/////////////////spherical harmonics visualiser
(
var data;
var az=0,el=0;
var m=600,sph,az1,el1,pl=0,daz,del,harm,mag,r;
var r1,harm1,r2,harm2,rad;
var run = true,n=12;
var ot=0.degrad,mk=0,size=1;
~data=[];

1.do{

data = (144*8).collect{

	az=~az.[pl];
	el=~el.[pl];
	//mag=1000;
	// mag=(Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho/(2.sqrt))+(Cartesian(~qx.[pl],~qy.[pl],~magz.[pl]).rho/(2.sqrt));
				 mag=(Cartesian(~magx.[pl],~magy.[pl],~magz.[pl]).rho/(2.sqrt));
		// mag=~magz.[pl];
	pl=pl+1;
			//mk=(mk+((size*2.pow(n/12))-((size*2.pow(n/12))/1.6180339887499))).wrap(0,size*2.pow(n/12));
		mk=(mk+250).wrap(1,1000);
		//sph=Spherical(mag*mk,az,el).asCartesian.asArray;
		sph=Spherical(1000,az,el).asCartesian.asArray;
};
	//pl=0;
	//mk=(mk+(1200-(1200/1.6180339887499))).wrap(0,1200);
	~data=~data++data;
};

w = Window.new("3D Scatterplot", Rect(40,40, 800, 800)).front;

~v = UserView.new(w,Rect(0,0,800,800)).background_(Color.black);
a = ScatterView3d(~v, Rect(0,0, 800,800), ~data, [-1000, 1000].asSpec,[-1000, 1000].asSpec,[-1000, 1000].asSpec);
a.drawMethod = \fillRect;
a.symbolSize = 1;
a.symbolColor = Color.white;
a.background = Color.black;

~v.animate;
~v.drawFunc ={
Pen.translate(400,400);

		a.rot(ot,ot,ot);
    ~v.refresh;

		ot=ot+0.1.degrad;

};
{ while { run } {~v.background_(Color.black); ~v.refresh; (1/1000).wait } }.fork(AppClock);
)


/////////////////spherical harmonics
(
{
var  sph1,sph2,sph3,sph4,sph5,sph6,sph7,m_x=1,m_y=1,m_z=1,qx,qy,mq=2;
var az1=0,el1=0,az2=0,el2=0,az3=0,el3=0,mag,mag_x,mag_y,mag_z,mag_qx,mag_qy;
var az4=0,el4=0,az5=0,el5=0,az6=0,el6=0,az7=0,el7=0;
var azimuth,elevation,magnitudex,magnitudey,magnitudez,angle=0,n=12;
var sphx,sphy,sphz,azx,elx,azy,ely,azz,elz,plx=1,ply=1,plz=1;
var num=1.neg;
var ellipsis=[1,1,1],spread=1;
var mag1=1,mag2=1,mag3=1,mag4=1,mag5=1,mag6=1,mag7=1;
	~az=[];~el=[];~magx=[];~magy=[];~magz=[];~qx=[];~qy=[];

//	spread = if(m_z < 1) { 1 / m_z } { m_z };

	144.do{
azimuth=8.collect{
			az1 = (az1+((180*2.pow(n/12))-((180*2.pow(n/12))/1.6180339887499))).wrap((90*2.pow(n/12)).neg,(90*2.pow(n/12)));
		   el1 = (el1+((90*2.pow(n/12))-((90*2.pow(n/12))/1.6180339887499))).wrap((45*2.pow(n/12)).neg,(45*2.pow(n/12)));

//	mag1=(mag1+(1-(1/1.6180339887499))).wrap(0,1);
sph1=(Spherical(mag1,(az1.degrad+angle.degrad).wrap(pi.neg,pi),(el1.degrad+angle.degrad.wrap((pi/2).neg,(pi/2))).wrap((pi/2).neg,(pi/2)))).theta.round(0.000000000001);

	};

elevation=8.collect{
				az2 = (az2+((180*2.pow(n/12))-((180*2.pow(n/12))/1.6180339887499))).wrap((90*2.pow(n/12)).neg,(90*2.pow(n/12)));
			el2 = (el2+((90*2.pow(n/12))-((90*2.pow(n/12))/1.6180339887499))).wrap((45*2.pow(n/12)).neg,(45*2.pow(n/12)));

	//mag2=(mag2+(1-(1/1.6180339887499))).wrap(0,1);
		sph2=(Spherical(mag2,(az2.degrad+angle.degrad).wrap(pi.neg,pi),(el2.degrad+angle.degrad.wrap((pi/2).neg,(pi/2))).wrap((pi/2).neg,(pi/2)))).phi.round(0.000000000001);

	};

magnitudex=	8.collect{
			az3 = (az3+((180*2.pow(n/12))-((180*2.pow(n/12))/1.6180339887499))).wrap((90*2.pow(n/12)).neg,(90*2.pow(n/12)));
			el3 = (el3+((90*2.pow(n/12))-((90*2.pow(n/12))/1.6180339887499))).wrap((45*2.pow(n/12)).neg,(45*2.pow(n/12)));

	//mag3=(mag3+(1-(1/1.6180339887499))).wrap(0,1);
	sph3=(Spherical(mag3,(az3.degrad+angle.degrad).wrap(pi.neg,pi),(el3.degrad+angle.degrad.wrap((pi/2).neg,(pi/2))).wrap((pi/2).neg,(pi/2))));

	 mag_x=((Complex(cos((sph3.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi)),cos((sph3.theta.round(0.000000000001)*m_x).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
			(Complex(cos((sph3.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),cos((sph3.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));

				};

magnitudey=	8.collect{
			az4 = (az4+((180*2.pow(n/12))-((180*2.pow(n/12))/1.6180339887499))).wrap((90*2.pow(n/12)).neg,(90*2.pow(n/12)));
				el4 = (el4+((90*2.pow(n/12))-((90*2.pow(n/12))/1.6180339887499))).wrap((45*2.pow(n/12)).neg,(45*2.pow(n/12)));

	//mag4=(mag4+(1-(1/1.6180339887499))).wrap(0,1);
	sph4=(Spherical(mag4,(az4.degrad+angle.degrad).wrap(pi.neg,pi),(el4.degrad+angle.degrad.wrap((pi/2).neg,(pi/2))).wrap((pi/2).neg,(pi/2))));

		 mag_y=((Complex(sin((sph4.theta.round(0.000000000001)*m_y).wrap(pi.neg,pi)),sin((sph4.theta.round(0.000000000001)*m_y).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
		 (Complex(cos((sph4.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),cos((sph4.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));
				};


qx=	8.collect{
			az5 = (az5+((180*2.pow(n/12))-((180*2.pow(n/12))/1.6180339887499))).wrap((90*2.pow(n/12)).neg,(90*2.pow(n/12)));
			el5 = (el5+((90*2.pow(n/12))-((90*2.pow(n/12))/1.6180339887499))).wrap((45*2.pow(n/12)).neg,(45*2.pow(n/12)));

		//mag5=(mag5+(1-(1/1.6180339887499))).wrap(0,1);
	sph5=(Spherical(mag5,(az5.degrad+angle.degrad).wrap(pi.neg,pi),(el5.degrad+angle.degrad).wrap((pi/2).neg,(pi/2)).wrap((pi/2).neg,(pi/2))));


mag_qx=((((Complex(cos(((sph5.theta.round(0.000000000001))*mq).wrap(pi.neg,pi)),
cos(((sph5.theta.round(0.000000000001))*mq).wrap(pi.neg,pi))))*
(Complex(sin((sph5.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((sph5.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((sph5.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),
cos((sph5.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);
				};


qy=	8.collect{
			az6 = (az6+((180*2.pow(n/12))-((180*2.pow(n/12))/1.6180339887499))).wrap((90*2.pow(n/12)).neg,(90*2.pow(n/12)));
			el6 = (el6+((90*2.pow(n/12))-((90*2.pow(n/12))/1.6180339887499))).wrap((45*2.pow(n/12)).neg,(45*2.pow(n/12)));

	//mag6=(mag6+(1-(1/1.6180339887499))).wrap(0,1);
	sph6=(Spherical(mag6,(az6.degrad+angle.degrad).wrap(pi.neg,pi),(el6.degrad+angle.degrad.wrap((pi/2).neg,(pi/2))).wrap((pi/2).neg,(pi/2))));

 mag_qy=((((Complex(sin(((sph6.theta.round(0.000000000001))*mq).wrap(pi.neg,pi)),
sin(((sph6.theta.round(0.000000000001))*mq).wrap(pi.neg,pi))))*
(Complex(sin((sph6.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((sph6.phi.round(0.000000000001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((sph6.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))),
cos((sph6.phi.round(0.000000000001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);
				};


magnitudez=	8.collect{
			az7 = (az7+((180*2.pow(n/12))-((180*2.pow(n/12))/1.6180339887499))).wrap((90*2.pow(n/12)).neg,(90*2.pow(n/12)));
			el7 = (el7+((90*2.pow(n/12))-((90*2.pow(n/12))/1.6180339887499))).wrap((45*2.pow(n/12)).neg,(45*2.pow(n/12)));

//mag7=(mag7+(1-(1/1.6180339887499))).wrap(0,1);
sph7=(Spherical(mag7,(az7.degrad+angle.degrad).wrap(pi.neg,pi),(el7.degrad+angle.degrad.wrap((pi/2).neg,(pi/2))).wrap((pi/2).neg,(pi/2))));

//if(
//m_z.even,
mag_z=(Complex(sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread)
			//,
//mag_z=(Complex(sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sph7.phi.round(0.000000000001)*m_z).wrap((pi/2).neg,(pi/2)))).rho(2.sqrt)).pow(spread);
			//);
////z axis   ambi..  sin for odd numbers, cos for even
				};

angle=(angle+((180*2.pow(n/12))-((180*2.pow(n/12))/1.6180339887499))).wrap((180*2.pow(n/12)).neg,(180*2.pow(n/12)));
~az=~az++azimuth;~el=~el++elevation;
~magx=~magx++magnitudex;~magy=~magy++magnitudey;~magz=~magz++magnitudez;
~qx=~qx++qx;~qy=~qy++qy;
		az1=0;el1=0;az2=0;el2=0;az3=0;el3=0;
		az4=0;el4=0;az5=0;el5=0;az6=0;el6=0;az7=0;el7=0;
	}
}.value;
)



/////////////////////////////////////sound design envelope filter

/(
SynthDef(\envFilter, {
    var sig, env, cutoff, filtered;

    // Sawtooth oscillator as input
    sig = Saw.ar(100, 0.3);

    // Envelope: attack, decay, sustain, release
    env = EnvGen.kr(
        Env.adsr(0.01, 0.2, 0.0, 0.5), // A-D-S-R shape
        gate: \gate.kr(1),             // trigger via gate
        doneAction: 2                  // free when done if gate is 0
    );

    // Map envelope value to filter cutoff
    cutoff = LinExp.kr(env, 0, 1, 200, 5000);

    // Resonant low-pass filter
    filtered = RLPF.ar(sig, cutoff, 0.2);

    Out.ar(0, filtered);
}).add;
)


// Example: play it
x = Synth(\envFilter);
x.set(\gate, 0);  // release


///////////////drone
(
Server.default = s = Server.local;
////server setup
s.options.memSize = 8192*8;
s.options.numInputBusChannels=0;
MIDIClient.init;
MIDIIn.connectAll;
(
s.waitForBoot{
	Tdef(\cmrc, {
	(
SynthDef.new(\drone,{

	arg gain=1,low=7168,high=0,tone=0,mix=0,room=0;
	var freqa,freqb,funda,fundb,n=0,m,ph,linex,liney,interval=2.pow(6/12),n1,n2,amp1,amp2,m1,m2,alpha;
	var goldenR=45,silverR=45,sig1,sig2,sig3,sig4,note=28*2.pow(6/12),bank=18,sig,copperR=0,out1,out2,out3,out4,fm1,fm2;


bank.do{

n1=2.pow(tone/56).round(0.0001);
//n2=2.pow((tone*(1/1))/992).round(0.0001);
n2=2.pow((tone*10)/992).round(0.0001);

funda=note*n1;
fundb=note*n2;
					alpha= 12.rand.wrap(8,12);
	n=n+1;
	m1=n*interval;
					///with lamdoma algebraic formula m=(n+1)/1 sawtooth///  m=(n+a)/a _ y=(x+a)/x  lamdoma
				m2=n*(pi+interval)/interval;
					m1.postln;

							ph=goldenR.degrad;
linex=exp(Complex(0,1)*silverR.degrad).real.round(0.0001).abs;
liney=exp(Complex(0,1)*silverR.degrad).imag.round(0.0001).abs.neg;

	copperR=(copperR+(360/bank)).round(0.0001);
		goldenR=(goldenR+(360-(360/((1+5.sqrt)/2)))).wrap(180.neg,180).round(0.0001);
		silverR=(silverR+(360-(360/(1+2.sqrt)))).wrap(180.neg,180).round(0.0001);

	freqa=funda*m1;
	freqb=fundb*m2;

	amp1=m1.reciprocal*n1.reciprocal;
	amp2=m2.reciprocal*n2.reciprocal;

	fm1=LFNoise1.ar(amp1.reciprocal,amp1);
	fm2=LFNoise1.ar(amp2.reciprocal,amp2);

					//sig1=(LPF.ar(Pulse.ar(freqa*3,width:0.5,mul:amp1).abs,low/4)*SinOsc.ar(freqa,ph,amp1));
					//sig2=(LPF.ar(Pulse.ar(freqb*3,width:0.5,mul:amp2).abs,low/4)*SinOsc.ar(freqb,ph,amp2));
					sig1=(LPF.ar(Pulse.ar((freqa*3)+fm1,width:0.5,mul:amp1).abs,low/8)*SinOsc.ar(freqa+fm1,ph,amp1));
					sig2=(LPF.ar(Pulse.ar((freqb*3)+fm2,width:0.5,mul:amp2).abs,low/8)*SinOsc.ar(freqb+fm2,ph,amp2));
					sig3=(LPF.ar(Pulse.ar((freqa*3)+fm1+alpha,width:0.5,mul:amp1).abs,low/8)*SinOsc.ar(freqa+fm1+alpha,ph,amp1));
					sig4=(LPF.ar(Pulse.ar((freqb*3)+fm2+alpha,width:0.5,mul:amp2).abs,low/8)*SinOsc.ar(freqb+fm2+alpha,ph,amp2));

sig1=LPF.ar(sig1,low);sig2=LPF.ar(sig2,low);
sig1=HPF.ar(sig1,high);sig2=HPF.ar(sig2,high);
sig3=LPF.ar(sig3,low);sig4=LPF.ar(sig4,low);
sig3=HPF.ar(sig3,high);sig4=HPF.ar(sig4,high);


out1=FreeVerb.ar(sig1,mix,room,mul:mix*2);
out2=FreeVerb.ar(sig2,mix,room,mul:mix*2);
out3=FreeVerb.ar(sig3,mix,room,mul:mix*2);
out4=FreeVerb.ar(sig4,mix,room,mul:mix*2);

					//sig=sig1+sig2;

//	Out.ar(0,Pan2.ar(out1,linex,gain));Out.ar(0,Pan2.ar(out2,liney,gain));
Out.ar(0,Pan2.ar(out1,linex,gain));Out.ar(0,Pan2.ar(out1,liney,gain));
Out.ar(0,Pan2.ar(out2,linex,gain));Out.ar(0,Pan2.ar(out2,liney,gain));
Out.ar(0,Pan2.ar(out3,linex,gain*room));Out.ar(0,Pan2.ar(out3,liney,gain*room));
Out.ar(0,Pan2.ar(out4,linex,gain*room));Out.ar(0,Pan2.ar(out4,liney,gain*room));
//Out.ar(0,Pan2.ar(sig,linex,gain));Out.ar(0,Pan2.ar(sig,liney,gain));
			}
}).add;);
			1.wait;
	~synth=Synth.new(\drone,[\gain,1,\tone,0,\low,16256,\high,56 ,\mix,0.5,\room,1]).register;//s.record
	//1.wait;
	(
		(
MIDIdef.cc(\midi1,{ |val, num, chan, src|
		var l;
	//[val, num, chan, src].postln;
		l=val.linlin(0,127,16256,56).round(0.0001);
		l.postln;
		if(~synth.isPlaying,{~synth.set(\low,l)});
},25);
	);
	(
MIDIdef.cc(\midi2,{ |val, num, chan, src|
		 var h;
	//[val, num, chan, src].postln;
	h=val.linlin(0,127,56,992).round(0.0001);
		h.postln;
		if(~synth.isPlaying,{~synth.set(\high,h)});
},24);
	);
		(
MIDIdef.cc(\midi3,{ |val, num, chan, src|
		var g;
	//[val, num, chan, src].postln;
	g=val.linlin(0,127,0,1).round(0.0001);
		g.postln;
		if(~synth.isPlaying,{~synth.set(\gain,g)});
},23);
	);

	(
MIDIdef.cc(\midi4,{ |val, num, chan, src|
		var m;
	//[val, num, chan, src].postln;
	m=val.linlin(0,127,0.1,1).round(0.1);
		m.postln;
		if(~synth.isPlaying,{~synth.set(\mix,m)});
},22);
	);
		(
MIDIdef.cc(\midi5,{ |val, num, chan, src|
		var r;
	//[val, num, chan, src].postln;
	r=val.linlin(0,127,(0.0001),1).round(0.0001);
		r.postln;
		if(~synth.isPlaying,{~synth.set(\room,r)});
},21);
	);
					(
MIDIdef.cc(\midi6,{ |val, num, chan, src|
		var t;
	//[val, num, chan, src].postln;
		t=val.linlin(0,127,0,56).round(1).asInteger;
		t.postln;
		if(~synth.isPlaying,{~synth.set(\tone,t)});
},20);
	);

)
});
	Tdef(\cmrc).play;
}
))
