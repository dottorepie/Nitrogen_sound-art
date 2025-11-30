


(
var freq= 3,cuttof=8128;
{LPF.ar(Pulse.ar(freq,width:0.5).abs*SinOsc.ar(freq*1/2,mul:1),cuttof)}.play;
)




(
SynthDef(\kick, {
    var env,silver=45,bank=5,linex=0,liney=0,sig;
	var phs,golden=90,ton=2,freq,decay=2;

	freq = EnvGen.kr(Env([56*ton, 28],  [0.5], curve: -4)); // pitch drop
	env= EnvGen.kr(Env.perc(0.01, decay, curve: -4),doneAction:2,levelScale:0.7);
	//sig = SinOsc.ar(freq,freq/56) * env;

	bank.do{

linex=exp(Complex(0,1)*silver.degrad).real.round(0.00001).abs;
liney=exp(Complex(0,1)*silver.degrad).imag.round(0.00001).abs.neg;
phs=golden.degrad;

		sig=(LPF.ar(Pulse.ar((freq*32),width:0.5,mul:freq/56).abs,56*4)*SinOsc.ar(freq,phs,freq/56))*env;

sig = sig + (sig * BrownNoise.ar(0.001)); // add slight noise for punch

		Out.ar(0, Pan2.ar(sig,linex));
		Out.ar(0, Pan2.ar(sig,liney));

silver=(silver+(360-(360/(1+2.sqrt)))).wrap(180.neg,180).round(0.00001);
golden=(golden+(360-(360/((1+5.sqrt)/2)))).wrap(180.neg,180).round(0.0001);

	};
}).add;
)

TempoClock.default.tempo_(120/152);

//////////patterns
(
	(
		~kick=Pdef(\1, Pbind(\instrument, \kick,
			\dur,Pseq(~dur1,inf),
		))
);
)


(
~kick.play;
)

(
/////octahedron
(
~az1=[0.degrad,0.degrad,90.degrad,180.degrad,90.neg.degrad,0.degrad];
~el1=[90.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,90.degrad];
);

/////tetrahedron
(
~az2=[0.degrad,0.degrad,90.degrad,180.degrad,90.neg.degrad,0.degrad];
~el2=[90.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,90.degrad];
);

//////octahedron
(
~az3=[0.degrad,0.degrad,90.degrad,180.degrad,90.neg.degrad,0.degrad];
~el3=[90.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,90.degrad];
);
)


////beat matrix
(
var plm1=0,plm2=0,plm3=0;
var tetrahedron=4,octahedron=6,cube=8,dur_mul=1;
var plx1=1.neg,ply1=1.neg,plz1=1.neg;
var plx2=1.neg,ply2=1.neg,plz2=1.neg;
var plx3=1.neg,ply3=1.neg,plz3=1.neg;
var angle_a=360/2,angle_b=360/2,angle_c=360/2;
var axis_xyz=[1,1,1].normalizeSum.sqrt,axis;
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

//angle_a=(angle_a+(360/8)).wrap(0,360);
//angle_b=(angle_b+(360/8)).wrap(0,360);
//angle_c=(angle_c+(360/8)).wrap(0,360);

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