/*(
var win,view,red,green,blue;

~controlBus = Bus.control(s, 1);
~controlBus1 = Bus.control(s, 1);
~controlBus2 = Bus.control(s, 1);

    // Create a window
    win = Window("RGB Audio Visualizer", Rect(100, 100, 400, 400));
    view = UserView(win, win.view.bounds);

  red = ~controlBus.getSynchronous;
green = ~controlBus1.getSynchronous;
 blue = ~controlBus2.getSynchronous;

    // Drawing function
    view.drawFunc = {
        Pen.fillColor = Color(red, green, blue);
        Pen.fillRect(view.bounds);
    };

    win.front;

)*/
~a = Synth(\painting);
~a.free
(
var win,wx=0,wy=0;
//Window.closeAll;

~amp1 = 0;
~amp2 = 0;
~amp3 = 0;
~amp4= 0;
~amp5 = 0;
~amp6= 0;
~amp7= 0;

win = Window("RGB Audio Visualizer", Rect(10, 10, 600, 600));
~v1 = UserView(win, Rect(0,0,600,600)).background_(Color.black);

SynthDef(\painting, {
	var amp1 = (InFeedback.ar(2).abs);
	var amp2 = (InFeedback.ar(3).abs);
	var amp3 = (InFeedback.ar(4).abs);
	var amp4 = (InFeedback.ar(0)*100);
	var amp5 = (InFeedback.ar(1)*100);
	//var amp6 = Amplitude.ar(InFeedback.ar(2,100));
	//var amp7 = Amplitude.ar(InFeedback.ar(3,100));

	SendReply.ar(Impulse.ar(60), '/amp1', amp1);
	SendReply.ar(Impulse.ar(60), '/amp2', amp2);
	SendReply.ar(Impulse.ar(60), '/amp3', amp3);
	SendReply.ar(Impulse.ar(60), '/amp4', amp4);
	SendReply.ar(Impulse.ar(60), '/amp5', amp5);
	//SendReply.ar(Impulse.ar(60), '/amp6', amp6);
	//SendReply.ar(Impulse.ar(60), '/amp7', amp7);
}).add;

// OSC
OSCdef(\ampt1, { |msg|
	~amp1 = msg[3];
	defer { ~v1.refresh };
}, '/amp1');

OSCdef(\ampt2, { |msg|
	~amp2 = msg[3];
	defer { ~v1.refresh };
}, '/amp2');

OSCdef(\ampt3, { |msg|
	~amp3 = msg[3];
	defer { ~v1.refresh };
}, '/amp3');

OSCdef(\ampt4, { |msg|
	~amp4 = msg[3];
	defer { ~v1.refresh };
}, '/amp4');

OSCdef(\ampt5, { |msg|
	~amp5 = msg[3];
	defer { ~v1.refresh };
}, '/amp5');

//OSCdef(\ampt6, { |msg|
//	~amp6 = msg[3];
//	defer { ~v1.refresh };
//}, '/amp6');

//OSCdef(\ampt7, { |msg|
//	~amp7 = msg[3];
//	defer { ~v1.refresh };
//}, '/amp7');

// ONE drawFunc
~v1.drawFunc = {
	1.do{

		Pen.translate(10,10);
	Pen.fillColor = Color(~amp1, ~amp2, ~amp3);
	Pen.fillRect(Rect(wx+~amp4,wy+~amp5,500,500));
	//Pen.fillColor = Color(1, 1, 1, ~amp2);
	//Pen.fillRect(Rect(wx+300,wy+0,300,300));
	//Pen.fillColor = Color(0, 0, 0, ~amp4);
	//Pen.fillRect(Rect(wx+0,wy+300,300,300));
	//Pen.fillColor = Color(0, 0, 0, ~amp3);
	//Pen.fillRect(Rect(wx+300,wy+300,300,300));
	}
};

win.front;
)


TempoClock.default.tempo_(120/20);


// edit: forgot loading the buffer
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");





///////////////



