(
var data,run = true,w,b,x1,y1,z1,x2,y2,z2,x3,y3,z3,r,a,core=2;
var ot=0.degrad,sph,sc=100,x,y,z,origin1,origin2,origin3,perimeter;
var point1,point2,point3,az1,az2,az3,el1,el2,el3,m1,m2,m3;


~data = [];
~data1 = [];


w = Window.new("3D Scatterplot", Rect(40,40, 1200, 1200)).front;

~v = UserView.new(w,Rect(0,0,1200,1200)).background_(Color.black);

 a = ScatterView3d(~v, Rect(0,0, 1200,1200), ~data, [-1000, 1000].asSpec,[-1000, 1000].asSpec,[-1000, 1000].asSpec);
a.drawMethod = \fillOval;
a.symbolSize = 4;
a.symbolColor = Color.red;
a.background = Color.white;

b = ScatterView3d(~v, Rect(0,0, 1200,1200), ~data1, [-1000, 1000].asSpec,[-1000, 1000].asSpec,[-1000, 1000].asSpec);
b.drawMethod = \fillOval;
b.symbolSize = 6;
b.symbolColor = Color.blue;
b.background = Color.clear;

~v.animate;
~v.drawFunc ={
Pen.translate(400,400);


		b.rot(ot,ot,ot);
	ot=ot+1.degard;
//	a.rot(x,y,z);


    ~v.refresh;

};

{ while { run } {~v.background_(Color.black); ~v.refresh; (1/100).wait } }.fork(AppClock);

  r= Routine({loop{

	x=~controlBus_x.getSynchronous*sc*core;
	y=~controlBus_y.getSynchronous*sc*core;
	z=~controlBus_z.getSynchronous*sc*core;

	x1=~controlBus_1a.getSynchronous*sc;
	y1=~controlBus_2a.getSynchronous*sc;
	z1=~controlBus_3a.getSynchronous*sc;

//	x2=~controlBus_1b.getSynchronous*sc;
//	y2=~controlBus_2b.getSynchronous*sc;
//	z2=~controlBus_3b.getSynchronous*sc;

//	x3=~controlBus_1c.getSynchronous*sc;
//	y3=~controlBus_2c.getSynchronous*sc;
//	z3=~controlBus_3c.getSynchronous*sc;

	origin1=Cartesian(x1,y1,z1);
//	origin2=Cartesian(x2,y2,z2);
//	origin3=Cartesian(x3,y3,z3);

	perimeter=Cartesian(x,y,z);

	az1=(origin1+perimeter).theta;
//	az2=(origin2+perimeter).theta;
//	az3=(origin3+perimeter).theta;
	el1=(origin1+perimeter).phi;
	//el2=(origin2+perimeter).phi;
	//el3=(origin3+perimeter).phi;
	m1=(origin1+perimeter).rho;
	//m2=(origin2+perimeter).rho;
	//m3=(origin3+perimeter).rho;

	point1=Spherical(m1,az1,el1);
	//point2=Spherical(m2,az2,el2);
	//point3=Spherical(m3,az3,el3);




	//~data=[ [point1.x,point1.y,point1.z], [point2.x,point2.y,point2.z], [point3.x,point3.y,point3.z] ];
	~data=[ [point1.x,point1.y,point1.z] ];
~data1=[ [point1.x+20,point1.y+20,point1.z+20] ];


 	b.data = ~data;            // Update ScatterView3d
//	a.data = ~data1;
0.001.wait
};

});

r.play;
)
