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
a.free
(
var win,wx=0,wy=0;
Window.closeAll;

~amp1 = 0;
~amp2 = 0;
~amp3 = 0;

win = Window("RGB Audio Visualizer", Rect(100, 100, 300, 300));
~v1 = UserView(win, Rect(0,0,300,300));

a = {
	var amp1 = Amplitude.ar(InFeedback.ar(4,100));
	var amp2 = Amplitude.ar(InFeedback.ar(5,100));
	var amp3 = Amplitude.ar(InFeedback.ar(6,100));

	SendReply.ar(Impulse.ar(120), '/amp1', amp1);
	SendReply.ar(Impulse.ar(120), '/amp2', amp2);
	SendReply.ar(Impulse.ar(120), '/amp3', amp3);
}.play;

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

// ONE drawFunc
~v1.drawFunc = {
	1.do{

	Pen.fillColor = Color(~amp1, ~amp2, ~amp3);
	Pen.fillRect(Rect(wx,wy,300,300));
	}
};

win.front;
)


TempoClock.default.tempo_(120/20);


// edit: forgot loading the buffer
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");





///////////////



