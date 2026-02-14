(
var data,run = true,w,b,x1,y1,z1,x2,y2,z2,x3,y3,z3,r,a;
var ot=0.degrad,sph,d=1000,sc=56,x,y,z;


~data = [];
~data1 = [];


w = Window.new("3D Scatterplot", Rect(40,40, 1200, 1200)).front;

~v = UserView.new(w,Rect(0,0,1200,1200)).background_(Color.black);

 a = ScatterView3d(~v, Rect(0,0, 1200,1200), ~data, [-1000, 1000].asSpec,[-1000, 1000].asSpec,[-1000, 1000].asSpec);
 a.drawMethod = \fillOval;
 a.symbolSize = 4;
 a.symbolColor = Color.red;
a.background = Color.black;

b = ScatterView3d(~v, Rect(0,0, 1200,1200), ~data1, [-1000, 1000].asSpec,[-1000, 1000].asSpec,[-1000, 1000].asSpec);
b.drawMethod = \fillOval;
b.symbolSize = 6;
b.symbolColor = Color.blue;
b.background = Color.clear;

~v.animate;
~v.drawFunc ={
Pen.translate(400,400);

	x=~controlBus_x.getSynchronous;
	y=~controlBus_y.getSynchronous;
	z=~controlBus_z.getSynchronous;

		b.rot(x,y,z);
	a.rot(x,y,z);


    ~v.refresh;

};

{ while { run } {~v.background_(Color.black); ~v.refresh; (1/100).wait } }.fork(AppClock);

  r= Routine({loop{


	x1=~controlBus_1a.getSynchronous*sc;
	y1=~controlBus_2a.getSynchronous*sc;
	z1=~controlBus_3a.getSynchronous*sc;

	x2=~controlBus_1b.getSynchronous*sc;
	y2=~controlBus_2b.getSynchronous*sc;
	z2=~controlBus_3b.getSynchronous*sc;

	x3=~controlBus_1c.getSynchronous*sc;
	y3=~controlBus_2c.getSynchronous*sc;
	z3=~controlBus_3c.getSynchronous*sc;


	~data=[ [x1,y1,z1], [x2,y2,z2], [x3,y3,z3] ];
	~data1=[ [x1+20,y1+20,z1+20], [x2+20,y2+20,z2+20], [x3+20,y3+20,z3+20] ];


 	b.data = ~data;            // Update ScatterView3d
	a.data = ~data1;
0.01.wait
};

});

r.play;
)
