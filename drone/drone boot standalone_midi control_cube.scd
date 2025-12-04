
(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=8;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*4;
s.options.blockSize = 64;
s.options.maxNodes = 1024 * 2;
s.makeGui(w);
//s.options.sampleRate= 44100;
//s.recHeaderFormat="aiff";
//s.recSampleFormat ="int16";
//s.recChannels = 8;
//s.boot;
);


(
s.waitForBoot{
MIDIClient.init;
MIDIIn.connectAll;
s.meter;
s.freqscope;
s.scope;
	Tdef(\drone, {
	Buffer.freeAll;

		///cube
		(
~a = VBAPSpeakerArray.new(3,
[[45, 35.264390.neg], [135, 35.264390.neg], [45.neg, 35.264390.neg], [135.neg, 35.264390.neg],[45,35.264390],[135,35.264390],[45.neg,35.264390],[135.neg,35.264390]]);
	 ~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);
);
//////saw wavetable
		~w= Buffer.alloc(s,2048);
		{
var signal,wt,m=0,amp,ph=0;

~level=32.collect{m=m+1;amp=m.reciprocal};
		signal=Signal.sineFill(1024,~level,[0]);

wt = signal.asWavetable;
~w.loadCollection(wt);
//signal.plot;
		}.value;

(
SynthDef.new(\synth,{

	arg gain=1,low=7168,high=0,tone=0,band=1,lamdoma=1,brain=1,pan_speed=1;
	var gold=45,silver=45,gold_r=((1+5.sqrt)/2),silver_r=(1+2.sqrt),room=0.8.rand,mix=0.5;
	var freq,fund,n=0,m,phase,interval,alpha,cell_az,cell_el,pulsenum=4;
	var sig1,sig2,first=64,bank=7,out1,out2,fm,band_osc1,band_osc2,amp,ton;


bank.do{

ton=2.pow(tone/16256).round(0.0001);

fund=(first*lamdoma)*ton;
n=n+1;
interval=pi;
m=n*interval;
freq=fund*m;
amp=m.reciprocal*lamdoma.reciprocal;
phase=gold.degrad;

gold=(gold+(360-gold_r)).wrap(180.neg,180).round(0.0001);
silver=(silver+(360-silver_r)).wrap(180.neg,180).round(0.0001);
fm=LFNoise1.ar(amp,amp.reciprocal);
band_osc1=Osc.kr(~w.bufnum,band,phase:0.degrad).range(56,16256);
band_osc2=Osc.kr(~w.bufnum,band,phase:90.degrad).range(56,16256);

sig1=LPF.ar(Pulse.ar((freq*pulsenum)+fm,width:0.5,mul:amp).abs,low/4)*SinOsc.ar(freq+fm,phase,amp);
sig2=LPF.ar(Pulse.ar((freq*pulsenum).poll+fm+brain,width:0.5,mul:amp).abs,low/4)*SinOsc.ar(freq+fm+brain,phase,amp);

sig1=LPF.ar(sig1,low); sig2=LPF.ar(sig2,low); sig1=HPF.ar(sig1,high); sig2=HPF.ar(sig2,high);

					sig1=BPF.ar(sig1,band_osc1);
					sig2=BPF.ar(sig2,band_osc1);

cell_az=Osc.kr(~w.bufnum,pan_speed,phase:0.degrad).range(180.neg,180);
cell_el=Osc.kr(~w.bufnum,pan_speed,phase:90.degrad).range(90.neg,90);

out1=VBAP.ar(8,FreeVerb.ar(sig1,mix,room,mul:1),~b.bufnum,(silver+cell_az).wrap(180.neg,180),
(silver.wrap(90.neg,90)+cell_el).wrap(90.neg,90));

out2=VBAP.ar(8,FreeVerb.ar(sig2,mix,room,mul:1),~b.bufnum,(silver+cell_az).wrap(180.neg,180),
(silver.wrap(90.neg,90)+cell_el).wrap(90.neg,90));

	Out.ar(0,LeakDC.ar(out1)*gain); Out.ar(0,LeakDC.ar(out2)*gain);
			}
}).add;);

1.wait;
~synth=Synth.new(\synth,[\gain,1,\tone,0,\low,16256/2,\high,56,
			                     \pan_speed,10,\band,0.1,\lamdoma,2,\brain,0.01]).register;//s.record
1.wait;

	(
MIDIClient.init;
MIDIIn.connectAll;
		(
MIDIdef.cc(\midi_pot1,{ |val, num, chan, src|
		var gain;
	//[val, num, chan, src].postln;
	gain=val.linlin(0,127,0,1).round(0.0001);
		gain.postln;
		if(~synth.isPlaying,{~synth.set(\gain,gain)});
},26);
	);
	(
MIDIdef.cc(\midi_pot2,{ |val, num, chan, src|
		 var high;
	high=val.linlin(0,127,28,8128).round(0.0001);
		high.postln;
		if(~synth.isPlaying,{~synth.set(\high,high)});
},27);
	);
		(
MIDIdef.cc(\midi_pot3,{ |val, num, chan, src|
		var pan;
	pan=val.linlin(0,127,0.001,10).round(0.001);
		pan.postln;
		if(~synth.isPlaying,{~synth.set(\pan_speed,pan)});
},28);
	);

	(
MIDIdef.cc(\midi_pot4,{ |val, num, chan, src|
         var low;
	low=val.linlin(0,127,16256,56).round(0.0001);
		low.postln;
		if(~synth.isPlaying,{~synth.set(\low,low)});
},29);
	);
		(
MIDIdef.cc(\midi_pot5,{ |val, num, chan, src|
		var band;
	band=val.linlin(0,127,0.0001,10).round(0.0001);
		band.postln;
		if(~synth.isPlaying,{~synth.set(\band,band)});
},30);
	);
					(
MIDIdef.cc(\midi_pot6,{ |val, num, chan, src|
		var tone;
		tone=val.linlin(0,127,0,16256*4).round(1).asInteger;
		tone.postln;
		if(~synth.isPlaying,{~synth.set(\tone,tone)});
},31);
	);
		(
MIDIdef.cc(\midi_switch1,{ |val, num, chan, src|
		var brain;
					if(val=127){brain=2.9999.rand.wrap(0.5,3)}{brain=0.000001};
		brain.postln;
		if(~synth.isPlaying,{~synth.set(\brain,brain)});
},14);
	);
	(
MIDIdef.cc(\midi_switch2,{ |val, num, chan, src|
		 var brain;
				if(val=127){brain=6.9999.rand.wrap(4,7)}{brain=0.000001};
		brain.postln;
		if(~synth.isPlaying,{~synth.set(\brain,brain)});
},15);
	);
		(
MIDIdef.cc(\midi_switch3,{ |val, num, chan, src|
		var brain;
					if(val=127){brain=11.9999.rand.wrap(8,12)}{brain=0.000001};
		brain.postln;
		if(~synth.isPlaying,{~synth.set(\brain,brain)});
},16);
	);

	(
MIDIdef.cc(\midi_switch4,{ |val, num, chan, src|
         var brain;
					if(val=127){brain=14.9999.rand.wrap(12.5,15)}{brain=0.000001};
		brain.postln;
		if(~synth.isPlaying,{~synth.set(\brain,brain)});
},17);
	);
		(
MIDIdef.cc(\midi_switch5,{ |val, num, chan, src|
		var brain;
				if(val=127){brain=29.9999.rand.wrap(15,30)}{brain=0.000001};
		brain.postln;
		if(~synth.isPlaying,{~synth.set(\brain,brain)});
},18);
	);
					(
MIDIdef.cc(\midi_switch6,{ |val, num, chan, src|
		var brain;
				if(val=127){brain=109.9999.rand.wrap(30,110)}{brain=0.000001};
		brain.postln;
		if(~synth.isPlaying,{~synth.set(\brain,brain)});
},19);
	);

	(
MIDIdef.cc(\midi_switch7,{ |val, num, chan, src|
		var lamdoma;
				if(val=127){lamdoma=1/2}{lamdoma=1};
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\lamdoma,lamdoma)});
},20);
	);
	(
MIDIdef.cc(\midi_switch8,{ |val, num, chan, src|
		 var lamdoma;
				if(val=127){lamdoma=2/3}{lamdoma=1};
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\lamdoma,lamdoma)});
},21);
	);
		(
MIDIdef.cc(\midi_switch9,{ |val, num, chan, src|
		var lamdoma;
				if(val=127){lamdoma=1/1}{lamdoma=1};
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\lamdoma,lamdoma)});
},22);
	);

	(
MIDIdef.cc(\midi_switch10,{ |val, num, chan, src|
         var lamdoma;
				if(val=127){lamdoma=4/3}{lamdoma=1};
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\lamdoma,lamdoma)});
},23);
	);
		(
MIDIdef.cc(\midi_switch11,{ |val, num, chan, src|
		var lamdoma;
				if(val=127){lamdoma=3/2}{lamdoma=1};
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\lamdoma,lamdoma)});
},24);
	);
					(
MIDIdef.cc(\midi_switch12,{ |val, num, chan, src|
		var lamdoma;
				if(val=127){lamdoma=2/1}{lamdoma=1};
		lamdoma.postln;
		if(~synth.isPlaying,{~synth.set(\lamdoma,lamdoma)});
},25);
	);


)
});
	Tdef(\drone).play;
}
)
)





/*	r=val.linlin(0,127,(0.0001),1).round(0.0001);
		r.postln;
		if(~synth.isPlaying,{~synth.set(\room,r)});

	m=val.linlin(0,127,0.1,1).round(0.1);
		m.postln;
		if(~synth.isPlaying,{~synth.set(\mix,m)});*/