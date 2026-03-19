
(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=4;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*4;
s.options.blockSize = 64;
s.options.maxNodes = 1024 * 2;
//s.makeGui(w);
//s.options.sampleRate= 44100;
//s.recHeaderFormat="aiff";
//s.recSampleFormat ="int16";
//s.recChannels = 8;
//s.boot;
);

//
(
s.waitForBoot{
s.freqscope;
s.scope;
//s.makeWindow;
s.meter;
	Tdef(\drone, {
	Buffer.freeAll;
////sesor ased randomnes
//SerialPort.devices;
//~port = SerialPort.new("/dev/cu.usbserial-210",9600)

/*(
~charArray = [];
~getValues = Routine.new({

	var ascii;
	{ascii = ~port.read.asAscii;
		if(ascii.isDecDigit, {~charArray = ~charArray.add(ascii)});
		if(ascii == $a,{~val = ~charArray.collect(_.digit).convertDigits;
			~charArray =[];
		});
	}.loop;

}).play;
);*/


////// wavetables

		//oscillator table
		(
~n=1.neg;~array=992.collect{~n=~n+1;2.pow(~n/992)};
~n=(0-(pi/496)); ~ph=992.collect{~n=~n+(pi/496);};
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


		/////distortion table
		(
		~transfer_function= Env([0.8.neg,0,0.8],[1,1],[8,8.neg]).asSignal(1024);
			~transfer_function=~transfer_function+(Signal.sineFill(~signalSize,~array,~ph)/8);
		~transfer_function=~transfer_function.normalize;
		//	~transfer_function.plot;
			~dist=Buffer.loadCollection(s,~transfer_function.asWavetableNoWrap);
		);
(
			{
				var nn=1.neg;
		~scale=14.collect{nn=nn+1;Scale.phrygian.performDegreeToKey(nn,12)};
			}.value;
		);

		(
			{
				var nn=1.neg;
		~scale1=28.collect{nn=nn+1;Scale.dorian.performDegreeToKey(nn,12)};
			}.value;
		);
		////sound

(
SynthDef.new(\synth,{

	arg gain=1,low=992,tone1=0,tone2=0,pan=1,mix=0.3,panx=1,pany=1,room=0.5,pon=1,
				fu=32,drive=1,spread=1,drone_amp=1,pann=0,re=1,im=1,dron=0,drone=1,
				pneuma1=0,pneuma2=0,namp1=1,namp2=1,decay=2;

	var rq=1,attack,curve,band,azf=0,elf=0,q,r1,r2,sq1,sq2;
	var freq1,freq2,fund,amp1,amp2,control1,control2	,ds1,ds2,f1,f2,g1,g2,axis,spx,spy;
	var sig1,sig2,band_osc1,band_osc2,threshold1,threshold2,level=100;
	var band_osc3,band_osc4,b_x,b_y,gain1,gain2,env,azimuth,elevation;
	var mod_anglex,phasex,phasey,rq1,rq2,rq3,rq4, g_ch1,g_ch2,gn ,g_sum,g_avg ,ton1,ton2;
	var mod_angley,lfo,sph,loc1,loc2,g=((1+5.sqrt)/2),s=(1+2.sqrt),dr;

env=EnvGen.ar(Env.sine(decay),levelScale:100,doneAction:2);
fund=fu*(9/8);

ton1=2.pow(Select.kr(tone1.lag(0.0001), ~scale) /12).round(0.0001)*2.pow(dron.lag(0.0001)/992);
ton2=2.pow(Select.kr(tone2.lag(0.0001), ~scale) /12).round(0.0001)*2.pow(dron.lag(0.0001)/992);

				lfo=2.pow(pan/992);
					band=pann;
				axis=exp(Complex(re,im)*SinOsc.ar(lfo).range(pi,pi.neg));

loc1=axis.real; loc2=axis.imag;
b_x=2.pow(axis.real.round(1) /992);
b_y=2.pow(axis.imag.round(1) /992);


phasex=Complex(1,axis.real).theta+pneuma1;    phasey=Complex(1,axis.imag).theta+pneuma2;
freq1=(fund*ton1)*b_x.lag(0.0001);  freq2=(fund*ton2)*b_y.lag(0.0001);

dr=2.pow(drone.lag(0.1)/12)*2.pow(dron.lag(0.0001)/992);
f1=(fund)*b_x.lag(0.0001)*dr; f2=(fund)*b_y.lag(0.0001)*dr;

amp1=ton1.reciprocal*b_x.reciprocal;  amp2=ton2.reciprocal*b_y.reciprocal;

g1=b_x.reciprocal*dr.reciprocal*drone_amp.reciprocal*panx;
g2=b_y.reciprocal*dr.reciprocal*drone_amp.reciprocal*pany;


band_osc1=SinOsc.kr(b_x*2.pow(band.lag(0.0001)/992),phase:phasex).exprange(496,16256);
band_osc2=SinOsc.kr(b_y*2.pow(band.lag(0.0001)/992),phase:phasey).exprange(496,16256);
band_osc3=SinOsc.kr(b_x*2.pow(band.lag(0.0001)/992),phase:phasex.neg).exprange(496,16256);
band_osc4=SinOsc.kr(b_y*2.pow(band.lag(0.0001)/992),phase:phasey.neg).exprange(496,16256);

rq1=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_x*2.pow(band.lag(0.0001)/992),phase:phasex,mul:rq).exprange(0.1,1)]);
rq2=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_y*2.pow(band.lag(0.0001)/992),phase:phasey,mul:rq).exprange(0.1,1)]);
rq3=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_x*2.pow(band.lag(0.0001)/992),phase:phasex.neg,mul:rq).exprange(0.1,1)]);
rq4=Select.kr(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
			[DC.ar(rq),SinOsc.kr(b_y*2.pow(band.lag(0.0001)/992),phase:phasey.neg,mul:rq).exprange(0.1,1)]);


control1=SinOsc.ar(freq1,phase:phasex,mul:amp1);
control2=SinOsc.ar(freq2,phase:phasey,mul:amp2);


ds1=(LPF.ar((Osc.ar(~w1.bufnum,f1+1,phase:phasex,mul:level).abs*SinOsc.ar(f1+1,phase:phasex)),f1*2.pow(low.lag(0.0001)/992),g1)+
	LPF.ar((Osc.ar(~w1.bufnum,f1+1,phase:phasex+(pi/2),mul:level).abs*SinOsc.ar(f1+1,phase:phasex+(pi/2))),f1*2.pow(low.lag(0.0001)/992),g1)
					);
ds2=(LPF.ar((Osc.ar(~w1.bufnum,f2+1,phase:phasey,mul:level).abs*SinOsc.ar(f2+1,phase:phasey)),f2*2.pow(low.lag(0.0001)/992),g2)+
	LPF.ar((Osc.ar(~w1.bufnum,f2+1,phase:phasey+(pi/2),mul:level).abs*SinOsc.ar(f2+1,phase:phasey+(pi/2))),f2*2.pow(low.lag(0.0001)/992),g2)
					);

					sig1=(LPF.ar((Osc.ar(~w1.bufnum,freq1,phase:phasex,mul:level).abs*SinOsc.ar(freq1,phase:phasex)),freq1*2.pow(low.lag(0.0001)/992),amp1)+(ds1/2));		sig2=(LPF.ar((Osc.ar(~w1.bufnum,freq2,phase:phasey,mul:level).abs*SinOsc.ar(freq2,phase:phasey)),freq2*2.pow(low.lag(0.0001)/992),amp2)+(ds2/2));


	sig1=Select.ar(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
						[sig1,BPF.ar(BRF.ar(sig1,band_osc1.lag(0.1),rq1),band_osc3.lag(0.1),rq3)]);
	sig2=Select.ar(band.linlin((992*16).neg,((992*16).neg+1),0,1).round(1).asInteger,
						[sig2,BPF.ar(BRF.ar(sig2,band_osc2.lag(0.1),rq2),band_osc4.lag(0.1),rq4)]);

threshold1=(((343/0.15)/fund).reciprocal.ampdb/2.sqrt).dbamp;
threshold2=(((343/0.15)/fund).reciprocal.ampdb/2.sqrt).dbamp;

		sig1=HPF.ar(sig1,50);
		sig2=HPF.ar(sig2, 50);
		sig1=Compander.ar(sig1,control1,threshold1,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);
		sig2=Compander.ar(sig2,control2,threshold2,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);

	///distortion
		sig1 = (tanh(sig1.softclip*2.pow(drive/992))) / (1 + (tanh(sig1.softclip*2.pow(drive/992))).abs);
		sig2 =  (tanh(sig2.softclip*2.pow(drive/992))) / (1 + (tanh(sig2.softclip*2.pow(drive/992))).abs);

	///final out
					gain1=gain*rq1.sqrt.reciprocal*env*namp1;
					gain2=gain*rq2.sqrt.reciprocal*env*namp2;


					g_ch1=(axis.real*Complex(1,0).real*SinOsc.ar(pon,(pi*(4/4)))+
						(axis.imag*Complex(1,0).imag*SinOsc.ar(pon,((pi/2)*(4/4))))).max(0);
					g_ch2=(axis.real*Complex(1,0).real*SinOsc.ar(pon,(pi*(1/4)))+
					    (axis.imag*Complex(1,0).imag*SinOsc.ar(pon,((pi/2)*(1/4))))).max(0);

gn = [g_ch1, g_ch2];   g_sum = gn.sum;  gn = gn / g_sum;
g_avg = gn.sum / gn.size;
gn = gn.collect { |gi| (1 - spread) * gi + spread * g_avg };
gn = gn/ gn.sum;
g_ch1 = gn[0];  g_ch2 = gn[1];



Out.ar(0,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.0001),room.lag(0.0001),mul:gain1)),0.9,0.01)*g_ch1*loc1);	Out.ar(0,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.0001),room.lag(0.0001),mul:gain1)),0.9,0.01)*g_ch2*loc1);

Out.ar(1,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.0001),room.lag(0.0001),mul:gain2)),0.9,0.01)*g_ch1*loc2);	Out.ar(1,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.0001),room.lag(0.0001),mul:gain2)),0.9,0.01)*g_ch2*loc2);

}).add;);

5.wait;
////durs
	({var m1=1.neg, m2=1.neg,b,c,n=0,bank=3,time=16.reciprocal,beat=1;

	~rea=[Complex(cos(1.5pi),sin(1.5pi)).real,
				Complex(cos(1.5pi+(2pi/3)),sin(1.5pi+(2pi/3)+(2pi/3))).real,
				Complex(cos(1.5pi+(2pi/3)+(2pi/3)),sin(1.5pi+(2pi/3)+(2pi/3))).real].round(0.0001);
	~ima=[Complex(cos(1.5pi),sin(1.5pi)).imag,
				Complex(cos(1.5pi+(2pi/3)),sin(1.5pi+(2pi/3)+(2pi/3))).imag,
				Complex(cos(1.5pi+(2pi/3)+(2pi/3)),sin(1.5pi+(2pi/3)+(2pi/3))).imag].round(0.0001);

			~dur1=[];~dur2=[];~dx=[];~dy=[]; ~durx=[]; ~dury=[]; ~dur=[]; ~rotation=0;

					1.do{
~x=bank.collect{
m1=m1+1;
	b=exp(Complex(~rea.[m1],~ima.[m1])*~rotation.degrad).real;
	2.pow(b).round(time);
};
~y=bank.collect{
m2=m2+1;
	c=exp(Complex(~rea.[m2],~ima.[m2])*~rotation.degrad).imag;
	2.pow(c).round(time);
};
 m1=1.neg; m2=1.neg;  ~dx=~dx++~x; ~dy=~dy++~y;   ~x=[]; ~y=[]; };

				bank.do{ ~dur1=~dur1++~dx.[n];n=n+1;};n=0;
		//	~durx = ~dur1.collect { |x| if (x == 0) { Rest(2) } { x }};

		bank.do{ ~dur2=~dur2++~dy.[n];n=n+1;};n=0;
			//	~dury = ~dur2.collect { |x| if (x == 0) { Rest(2) } { x }};


			~dur=~dur++~dur1++~dur2;

}.value;
);


(
~synth=Synth.new(\synth,[\gain,1,\drive,992*4,\fu,32,\tone1,0,\tone2,0,\pan,(992*8).neg,
		\mix,0.3,\drone_amp,1,\room,0.5,\pann,(992*16).neg,\pon,0.001,\pneuma1,0,\pneuma2,0,
			\panx,0.01,\pany,0.01,\spread,1,\namp1,1,\namp2,1,\decay,16,
			\re,0,\im,1,\dron,0,\drone,1]).register;
);

		(
MIDIClient.init;
MIDIIn.connectAll;

(
					(
MIDIdef.cc(\midi_pot1,{ |val, num, chan, src|
		var drive;
		drive=val.linlin(0,127,(992*1).neg,(992*16)).round(1).asInteger;
		drive.postln;
		if(~synth.isPlaying,{~synth.set(\drive,drive)});
},1);
						);

				(
MIDIdef.cc(\midi_pot2,{ |val, num, chan, src|
      		var pan;
			pan=val.linlin(0,127,(992*16).neg,(992*8)).round(1).asInteger;
		pan.postln;
		if(~synth.isPlaying,{~synth.set(\pan,pan)});
},2);
	);

									(
MIDIdef.cc(\midi_pot3,{ |val, num, chan, src|
		var pann;
			pann=val.linlin(0,127,(992*32).neg,(992*4)).round(1).asInteger;
		pann.postln;
		if(~synth.isPlaying,{~synth.set(\pann,pann)});
},3);
	);

												(
MIDIdef.cc(\midi_pot4,{ |val, num, chan, src|
		var dron;
			dron=val.linlin(0,127,0,992*2).round(1).asInteger;
		dron.postln;
		if(~synth.isPlaying,{~synth.set(\dron,dron)});
},4);
	);

														(
MIDIdef.cc(\midi_pot5,{ |val, num, chan, src|
		var pon;
			pon=val.linlin(0,127,0.001,4).round(0.0001);
		pon.postln;
		if(~synth.isPlaying,{~synth.set(\pon,pon)});
},5);
	);

														(
MIDIdef.cc(\midi_pot6,{ |val, num, chan, src|
		var spread;
			spread=val.linlin(0,127,0.0001,1).round(0.0001);
		spread.postln;
		if(~synth.isPlaying,{~synth.set(\spread,spread)});
},6);
	);

														(
MIDIdef.cc(\midi_pot7,{ |val, num, chan, src|
		var panx;
			panx=val.linlin(0,127,0.0001,1).round(0.0001);
		panx.postln;
		if(~synth.isPlaying,{~synth.set(\panx,panx)});
},7);
	);

																	(
MIDIdef.cc(\midi_pot8,{ |val, num, chan, src|
		var pany;
			pany=val.linlin(0,127,0.0001,1).round(0.0001);
		pany.postln;
		if(~synth.isPlaying,{~synth.set(\pany,pany)});
},8);
	);


												(
MIDIdef.cc(\midi_pot9,{ |val, num, chan, src|
				var re;
			re=val.linlin(0,127,1.neg,1).round(0.0001);
		re.postln;
		if(~synth.isPlaying,{~synth.set(\re,re)});
},9);
	);

													(
MIDIdef.cc(\midi_pot10,{ |val, num, chan, src|
				var im;
			im=val.linlin(0,127,1.neg,1).round(0.0001);
		im.postln;
		if(~synth.isPlaying,{~synth.set(\re,re)});
},10);
	);

														(
MIDIdef.cc(\midi_pot11,{ |val, num, chan, src|
		var mix;
					mix=val.linlin(0,127,0,1).round(0.0001);
		mix.postln;
		if(~synth.isPlaying,{~synth.set(\mix,mix)});
},11);
	);

														(
MIDIdef.cc(\midi_pot12,{ |val, num, chan, src|
		var room;
		room=val.linlin(0,127,0,1).round(0.0001);
		room.postln;
		if(~synth.isPlaying,{~synth.set(\room,room)});
},12);
	);

													(
MIDIdef.cc(\midi_pot13,{ |val, num, chan, src|

},13);
	);

														(
MIDIdef.cc(\midi_pot14,{ |val, num, chan, src|

},14);
	);
															(
MIDIdef.cc(\midi_pot15,{ |val, num, chan, src|

},15);
				);

								(
MIDIdef.cc(\midi_pot16,{ |val, num, chan, src|

},16);
	);
);

(
					(
MIDIdef.cc(\midi_seq_pot1,{ |val, num, chan, src|
		var s1;
		s1=val.linlin(0,127,0,14).round(1).asInteger;
		s1.postln;
		~s1=s1;
},17);
						);

				(
MIDIdef.cc(\midi_seq_pot2,{ |val, num, chan, src|
         var s2;
					s2=val.linlin(0,127,0,14).round(1).asInteger;
		s2.postln;
		~s2=s2;
},18);
	);

									(
MIDIdef.cc(\midi_seq_pot3,{ |val, num, chan, src|
		var s3;
			s3=val.linlin(0,127,0,14).round(1).asInteger;
		s3.postln;
		~s3=s3;
},19);
	);

												(
MIDIdef.cc(\midi_seq_pot4,{ |val, num, chan, src|
		var s4;
			s4=val.linlin(0,127,0,14).round(1).asInteger;
		s4.postln;
		~s4=s4;
},20);
	);

														(
MIDIdef.cc(\midi_seq_pot5,{ |val, num, chan, src|
		var s5;
			s5=val.linlin(0,127,0,14).round(1).asInteger;
		s5.postln;
		~s5=s5;
},21);
	);

														(
MIDIdef.cc(\midi_seq_pot6,{ |val, num, chan, src|
		var s6;
						s6=val.linlin(0,127,0,14).round(1).asInteger;
		s6.postln;
		~s6=s6;
},22);
	);

														(
MIDIdef.cc(\midi_seq_pot7,{ |val, num, chan, src|
		var s7;
			s7=val.linlin(0,127,0,14).round(1).asInteger;
		s7.postln;
		~s7=s7;
},23);
	);

																	(
MIDIdef.cc(\midi_seq_pot8,{ |val, num, chan, src|
		var s8;
			s8=val.linlin(0,127,0,14).round(1).asInteger;
		s8.postln;
		~s8=s8;
},24);
	);
);
(
			(
MIDIdef.cc(\midi_slider1,{ |val, num, chan, src|
		var gain;
	gain=val.linlin(0,127,0,1).round(0.0001);
		gain.postln;
		if(~synth.isPlaying,{~synth.set(\gain,gain)});
},49);
			);

											(
MIDIdef.cc(\midi_slider2,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0.0001,1).round(0.0001);
		th.postln;
~ss1=th
},25);
	);

														(
MIDIdef.cc(\midi_slider3,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0.0001,1).round(0.0001);
		th.postln;
~ss2=th

},26);
	);
(
MIDIdef.cc(\midi_slider4,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0.0001,1).round(0.0001);
		th.postln;
~ss3=th
},27);
	);

				(
MIDIdef.cc(\midi_slider5,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0.0001,1).round(0.0001);
		th.postln;
~ss4=th
},28);
			);
					(
MIDIdef.cc(\midi_slider6,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0.0001,1).round(0.0001);
		th.postln;
~ss5=th
},29);
			);
				(
MIDIdef.cc(\midi_slider7,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0.0001,1).round(0.0001);
		th.postln;
~ss6=th
},30);
	);

(
MIDIdef.cc(\midi_slider8,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0.0001,1).round(0.0001);
		th.postln;
~ss7=th
},31);
	);


	(
MIDIdef.cc(\midi_slider9,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0.0001,1).round(0.0001);
		th.postln;
~ss8=th
},32);
			));
			///comtroller 2
			(
					(
MIDIdef.cc(\midi_seq_pot1,{ |val, num, chan, src|
		var s1;
		s1=val.linlin(0,127,0,14).round(1).asInteger;
		s1.postln;
		~s10=s1;
},50,2);
						);

				(
MIDIdef.cc(\midi_seq_pot2,{ |val, num, chan, src|
         var s2;
					s2=val.linlin(0,127,0,14).round(1).asInteger;
		s2.postln;
		~s11=s2;
},51,2);
	);

									(
MIDIdef.cc(\midi_seq_pot3,{ |val, num, chan, src|
		var s3;
			s3=val.linlin(0,127,0,14).round(1).asInteger;
		s3.postln;
		~s12=s3;
},52,2);
	);

												(
MIDIdef.cc(\midi_seq_pot4,{ |val, num, chan, src|
		var s4;
			s4=val.linlin(0,127,0,14).round(1).asInteger;
		s4.postln;
		~s13=s4;
},53,2);
	);

														(
MIDIdef.cc(\midi_seq_pot5,{ |val, num, chan, src|
		var s5;
			s5=val.linlin(0,127,0,14).round(1).asInteger;
		s5.postln;
		~s14=s5;
},54,2);
	);

														(
MIDIdef.cc(\midi_seq_pot6,{ |val, num, chan, src|
		var s6;
						s6=val.linlin(0,127,0,14).round(1).asInteger;
		s6.postln;
		~s15=s6;
},55,2);
	);

														(
MIDIdef.cc(\midi_seq_pot7,{ |val, num, chan, src|
		var s7;
			s7=val.linlin(0,127,0,14).round(1).asInteger;
		s7.postln;
		~s16=s7;
},56,2);
	);

																	(
MIDIdef.cc(\midi_seq_pot8,{ |val, num, chan, src|
		var s8;
			s8=val.linlin(0,127,0,14).round(1).asInteger;
		s8.postln;
		~s17=s8;
},57,2);
	);
);
(
			(
MIDIdef.cc(\midi_slider1,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0.0001,1).round(0.0001);
		th.postln;
~ss10=th
},58,2);
			);

											(
MIDIdef.cc(\midi_slider2,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0.0001,1).round(0.0001);
		th.postln;
~ss11=th
},59,2);
	);

														(
MIDIdef.cc(\midi_slider3,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0.0001,1).round(0.0001);
		th.postln;
~ss12=th

},60,2);
	);
(
MIDIdef.cc(\midi_slider4,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0.0001,1).round(0.0001);
		th.postln;
~ss13=th
},61,2);
	);

				(
MIDIdef.cc(\midi_slider5,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0.0001,1).round(0.0001);
		th.postln;
~ss14=th
},62,2);
			);
					(
MIDIdef.cc(\midi_slider6,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0.0001,1).round(0.0001);
		th.postln;
~ss15=th
},63,2);
			);
					(
MIDIdef.cc(\midi_slider7,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0.0001,1).round(0.0001);
		th.postln;
~ss16=th
},64,2);
	);

(
MIDIdef.cc(\midi_slider8,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0.0001,1).round(0.0001);
		th.postln;
~ss17=th
},65,2);
	);


			);
						(
					(
MIDIdef.cc(\midi_seq_pot1,{ |val, num, chan, src|
		var s1;
		s1=val.linlin(0,127,0,14).round(1).asInteger;
		s1.postln;
		~s18=s1;
},66,2);
						);

				(
MIDIdef.cc(\midi_seq_pot2,{ |val, num, chan, src|
         var s2;
					s2=val.linlin(0,127,0,14).round(1).asInteger;
		s2.postln;
		~s19=s2;
},67,2);
	);

									(
MIDIdef.cc(\midi_seq_pot3,{ |val, num, chan, src|
		var s3;
			s3=val.linlin(0,127,0,14).round(1).asInteger;
		s3.postln;
		~s20=s3;
},68,2);
	);

												(
MIDIdef.cc(\midi_seq_pot4,{ |val, num, chan, src|
		var s4;
			s4=val.linlin(0,127,0,14).round(1).asInteger;
		s4.postln;
		~s21=s4;
},69,2);
	);

														(
MIDIdef.cc(\midi_seq_pot5,{ |val, num, chan, src|
		var s5;
			s5=val.linlin(0,127,0,14).round(1).asInteger;
		s5.postln;
		~s22=s5;
},70,2);
	);

														(
MIDIdef.cc(\midi_seq_pot6,{ |val, num, chan, src|
		var s6;
						s6=val.linlin(0,127,0,14).round(1).asInteger;
		s6.postln;
		~s23=s6;
},71,2);
	);

														(
MIDIdef.cc(\midi_seq_pot7,{ |val, num, chan, src|
		var s7;
			s7=val.linlin(0,127,0,14).round(1).asInteger;
		s7.postln;
		~s24=s7;
},72,2);
	);

																	(
MIDIdef.cc(\midi_seq_pot8,{ |val, num, chan, src|
		var s8;
			s8=val.linlin(0,127,0,14).round(1).asInteger;
		s8.postln;
		~s25=s8;
},73,2);
	);
);
(
			(
MIDIdef.cc(\midi_slider1,{ |val, num, chan, src|
		var s8;
			s8=val.linlin(0,127,0,14).round(1).asInteger;
		s8.postln;
		~s18=s8;
},74,2);
			);

											(
MIDIdef.cc(\midi_slider2,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0.0001,1).round(0.0001);
		th.postln;
~ss19=th
},75,2);
	);

														(
MIDIdef.cc(\midi_slider3,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0.0001,1).round(0.0001);
		th.postln;
~ss20=th

},76,2);
	);
(
MIDIdef.cc(\midi_slider4,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0.0001,1).round(0.0001);
		th.postln;
~ss21=th
},77,2);
	);

				(
MIDIdef.cc(\midi_slider5,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0.0001,1).round(0.0001);
		th.postln;
~ss22=th
},78,2);
			);
					(
MIDIdef.cc(\midi_slider6,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0.0001,1).round(0.0001);
		th.postln;
~ss23=th
},79,2);
			);
					(
MIDIdef.cc(\midi_slider7,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0.0001,1).round(0.0001);
		th.postln;
~ss24=th
},80,2);
	);

(
MIDIdef.cc(\midi_slider8,{ |val, num, chan, src|
		var th;
	th=val.linlin(0,127,0.0001,1).round(0.0001);
		th.postln;
~ss25=th
},81,2);
	);

			);

		);
		/////////////sequencer with midi
({
			var m1=1.neg, m2=1.neg, m3=1.neg,a,b,c,n=0,bank=4,time=32.reciprocal,beat=1,r=0;
			~r=0;		~r1=0;		~r2=0;
				(

			~dur1=[];~dur2=[];~dur3=[]; ~dx=[];~dy=[]; ~dz=[]; ~durx=[]; ~dury=[]; ~durz=[]; ~dur=[];

					1.do{
~x=bank.collect{
m1=m1+1;
					b=Spherical(beat,~az.[m1],~el.[m1]).rotate(~r).tilt(~r1).tumble(~r2).x.round(0.00001);
	2.pow(b).round(time);
};
~y=bank.collect{
m2=m2+1;
	c=Spherical(beat,~az.[m2],~el.[m2]).rotate(~r).tilt(~r1).tumble(~r2).y.round(0.00001);
	2.pow(c).round(time);
};
~z=bank.collect{
m3=m3+1;
	d=Spherical(beat,~az.[m3],~el.[m3]).rotate(~r).tilt(~r1).tumble(~r2).z.round(0.00001);
	2.pow(d).round(time);
}; m1=1.neg; m2=1.neg; m3=1.neg; ~dx=~dx++~x; ~dy=~dy++~y;  ~dz=~dz++~z;   ~x=[]; ~y=[]; ~z=[];  r=r+90.degrad; };

				bank.do{ ~dur1=~dur1++~dx.[n];n=n+1;};n=0;
		//	~durx = ~dur1.collect { |x| if (x == 0) { Rest(2) } { x }};

		bank.do{ ~dur2=~dur2++~dy.[n];n=n+1;};n=0;
			//	~dury = ~dur2.collect { |x| if (x == 0) { Rest(2) } { x }};

		bank.do{ ~dur3=~dur3++~dz.[n];n=n+1;};n=0;
			//	~durz = ~dur3.collect { |x| if (x == 0) { Rest(2) } { x }};

			~dur=~dur++~dur1++~dur2++~dur3;
);
		}.value);

						//	~seq = Pseq([1] ,inf).asStream;
		~seq1= Pseq(~dur1 ,inf).asStream;
		~seq2= Pseq(~dur2 ,inf).asStream;
		~seq3= Pseq(~dur3 ,inf).asStream;

				//leier string1
		(
	~str1= Routine({loop{



	~synth.set(\tone1, ~s1, \pneuma1,0, \namp1,~ss1)	;

    ~seq1.next.wait;

	~synth.set(\tone1, ~s2, \pneuma1,pi, \namp1,~ss2)	;

	    ~seq1.next.wait;

	~synth.set(\tone1, ~s3, \pneuma1,0, \namp1,~ss3)	;

	    ~seq1.next.wait;

	~synth.set(\tone1, ~s4, \pneuma1,pi, \namp1,~ss4)	;

	    ~seq1.next.wait;

	~synth.set(\tone1, ~s5, \pneuma1,0, \namp1,~ss5)	;

	    ~seq1.next.wait;

	~synth.set(\tone1, ~s6, \pneuma1,pi, \namp1,~ss6)	;

	    ~seq1.next.wait;

	~synth.set(\tone1, ~s7, \pneuma1,0, \namp1,~ss7)	;

	    ~seq1.next.wait;

	~synth.set(\tone1, ~s8, \pneuma1pi, \namp1,~ss8)	;

	    ~seq1.next.wait;
};
		}));

		///leier string2
		(
	~str2= Routine({loop{



	~synth.set(\tone2, ~s9, \pneuma2,0, \namp2,~ss9)	;

    ~seq2.next.wait;

	~synth.set(\tone2, ~s10, \pneuma2,pi, \namp2,~ss10)	;

	    ~seq2.next.wait;

	~synth.set(\tone2, ~s11, \pneuma2,0, \namp2,~ss11)	;

	    ~seq2.next.wait;

	~synth.set(\tone2, ~s12, \pneuma2,pi, \namp2,~ss12)	;

	    ~seq2.next.wait;

	~synth.set(\tone2, ~s13, \pneuma2,0, \namp2,~ss14)	;

	    ~seq2.next.wait;

	~synth.set(\tone2, ~s15, \pneuma2,pi, \namp2,~ss15)	;

	    ~seq2.next.wait;

	~synth.set(\tone2, ~s16, \pneuma2,0, \namp2,~ss16)	;

	    ~seq2.next.wait;

	~synth.set(\tone2, ~s17, \pneuma2,pi, \namp2,~ss17)	;

	    ~seq2.next.wait;
};
		}));

		///leier string2
		(
	~str3= Routine({loop{



	~synth.set(\tone3, ~s18, \pneuma3,0, \namp3,~ss18)	;

    ~seq3.next.wait;

	~synth.set(\tone3, ~s20, \pneuma3,pi, \namp3,~ss20)	;

	    ~seq3.next.wait;

	~synth.set(\tone3, ~s21, \pneuma3,0, \namp3,~ss21)	;

	    ~seq3.next.wait;

	~synth.set(\tone3, ~s22, \pneuma3,pi, \namp3,~ss22)	;

	    ~seq3.next.wait;

	~synth.set(\tone3, ~s23, \pneuma3,0, \namp3,~ss23)	;

	    ~seq3.next.wait;

	~synth.set(\tone3, ~s24, \pneuma3,pi, \namp3,~ss24)	;

	    ~seq3.next.wait;

	~synth.set(\tone3, ~s25, \pneuma3,0, \namp3,~ss25)	;

	    ~seq3.next.wait;

	~synth.set(\tone3, ~s26, \pneuma3,pi, \namp3,~ss26)	;

	    ~seq3.next.wait;
};
		}));

	~str1.play;
	~str2.play;
	~str3.play;

		TempoClock.default.tempo_(2);

	});
	Tdef(\drone).play;
}
)
)
~str1.stop;
~str2.stop;
~sr3.stop

	~r=0;		~r1=0;		~r2=0;



		TempoClock.default.tempo_(2);


(
~synth=Synth.new(\synth,[\gain,1,\drive,992*2,\fu,32,\tone1,0,\tone2,0,\tone3,0,\low,992*0,\pan,(992*16).neg,
		\mix,0.3,\drone_amp,1,\room,0.5,\m,1,\pann,(992*16).neg,\pon,0.001,\pneuma,0, \namp,1,
			\x,1,\a,1,\panx,0.01,\pany,0.01,\panz,0.01,\spread,1,
			\az,pi/4,\el,pi/8,\azr,992,\dron,0,\drone,1,\sc,1]).register;
);




////////////////////////////////////////
			////sequencer randomness

	~s= Routine({loop{

	thisThread.randSeed = ~val;

		~val.postln;

	~synth.set(\tone, (56).rand)	;

2.wait
};
});

	~s.play;
/////server based randomes
(
~seq = Pseq(~dur, inf).asStream;
	~s= Routine({loop{


	~synth.set(\tone, (56).rand)	;

    ~seq.next.wait;
};
});
)

~s.stop



Routine({
    loop {
        6*3600.wait;   // every 6 hours
        s.reboot;
    }
}).play;



