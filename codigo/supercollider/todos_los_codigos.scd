#+BEGIN_SRC supercollider :results none
// Monocordio pitagórico en SuperCollider
(
SynthDef(\monocordio, { |out=0, freq=440, amp=0.3, pan=0|
    var sig = SinOsc.ar(freq, 0, amp) * EnvGen.kr(
        Env.perc(0.01, 1.5, 1, -4),
        doneAction: 2
    );
    Out.ar(out, Pan2.ar(sig, pan));
}).add;

Routine({
    [1, 2, 1.5, 4/3, 1.25, 1.2, 1].do { |ratio, i|
        Synth(\monocordio, [\freq, 440 * ratio]);
        (1.5).wait;
    };
}).play;
)
#+END_SRC
#+BEGIN_SRC supercollider :results none
// Bach algorítmico: fuga a dos voces en SuperCollider
// El contrapunto como cálculo: cada voz es una función que depende de la otra

s.boot;

(
// SynthDef para una voz de la fuga (sonido de órgano simple)
SynthDef(\organo, { |out=0, freq=440, amp=0.1, gate=1|
    var sig, env;
    env = EnvGen.kr(Env.asr(0.02, 1, 0.1), gate, doneAction: 2);
    sig = Mix.ar([
        SinOsc.ar(freq, 0, 0.6),
        SinOsc.ar(freq * 2, 0, 0.2),
        SinOsc.ar(freq * 3, 0, 0.1)
    ]);
    sig = sig * env * amp;
    Out.ar(out, sig!2);
}).add;
)

// Esperar a que compile
0.5.wait;

// Sujeto de la fuga (tema principal) - BWV 846 adaptado
~sujeto = Pbind(
    \instrument, \organo,
    \midinote, Pseq([60, 64, 67, 72, 71, 67, 69, 65, 67, 64, 62, 60, 67, 65, 64, 62, 60], 1),
    \dur, Pseq([0.25, 0.25, 0.25, 0.5, 0.25, 0.25, 0.25, 0.25, 0.5, 0.25, 0.25, 0.5, 0.25, 0.25, 0.25, 0.25, 0.5], 1),
    \amp, 0.12
);

// Contrasujeto (segunda voz) - entra después, responde al sujeto
~contrasujeto = Pbind(
    \instrument, \organo,
    \midinote, Pseq([48, 52, 55, 60, 59, 55, 57, 53, 55, 52, 50, 48, 55, 53, 52, 50, 48], 1),
    \dur, Pseq([0.25, 0.25, 0.25, 0.5, 0.25, 0.25, 0.25, 0.25, 0.5, 0.25, 0.25, 0.5, 0.25, 0.25, 0.25, 0.25, 0.5], 1),
    \amp, 0.08
);

// Ejecutar las dos voces: la segunda entra después (stretto)
~voz1 = ~sujeto.play;
2.wait;  // La segunda voz entra dos segundos después
~voz2 = ~contrasujeto.play;

// Detener
~voz1.stop;
~voz2.stop;
)
#+END_SRC
#+BEGIN_SRC supercollider :results none
// Fuga a seis voces en SuperCollider
// Inspirado en Bach - cada voz entra en stretto

s.boot;

(
// SynthDef mejorado con más cuerpo para seis voces
SynthDef(\organo6, { |out=0, freq=440, amp=0.05, gate=1, pan=0|
    var sig, env;
    env = EnvGen.kr(Env.asr(0.03, 1, 0.15), gate, doneAction: 2);
    sig = Mix.ar([
        SinOsc.ar(freq, 0, 0.5),
        SinOsc.ar(freq * 2, 0, 0.15),
        SinOsc.ar(freq * 3, 0, 0.08),
        SinOsc.ar(freq * 4, 0, 0.04)
    ]);
    sig = sig * env * amp;
    Out.ar(out, Pan2.ar(sig, pan));
}).add;
)

0.5.wait;

(
// Sujeto principal (voz 1 - soprano)
~voz1 = Pbind(
    \instrument, \organo6,
    \midinote, Pseq([72, 76, 79, 84, 83, 79, 81, 77, 79, 76, 74, 72], 1),
    \dur, Pseq([0.5, 0.5, 0.5, 1.0, 0.5, 0.5, 0.5, 0.5, 1.0, 0.5, 0.5, 1.0], 1),
    \amp, 0.06,
    \pan, 0
);

// Respuesta real (voz 2 - contralto)
~voz2 = Pbind(
    \instrument, \organo6,
    \midinote, Pseq([60, 64, 67, 72, 71, 67, 69, 65, 67, 64, 62, 60], 1),
    \dur, Pseq([0.5, 0.5, 0.5, 1.0, 0.5, 0.5, 0.5, 0.5, 1.0, 0.5, 0.5, 1.0], 1),
    \amp, 0.05,
    \pan, -0.3
);

// Voz 3 (tenor) - entra en la quinta
~voz3 = Pbind(
    \instrument, \organo6,
    \midinote, Pseq([67, 71, 74, 79, 78, 74, 76, 72, 74, 71, 69, 67], 1),
    \dur, Pseq([0.5, 0.5, 0.5, 1.0, 0.5, 0.5, 0.5, 0.5, 1.0, 0.5, 0.5, 1.0], 1),
    \amp, 0.05,
    \pan, 0.3
);

// Voz 4 (bajo) - entra en la octava inferior
~voz4 = Pbind(
    \instrument, \organo6,
    \midinote, Pseq([48, 52, 55, 60, 59, 55, 57, 53, 55, 52, 50, 48], 1),
    \dur, Pseq([0.5, 0.5, 0.5, 1.0, 0.5, 0.5, 0.5, 0.5, 1.0, 0.5, 0.5, 1.0], 1),
    \amp, 0.06,
    \pan, 0
);

// Voz 5 - contrasujeto libre
~voz5 = Pbind(
    \instrument, \organo6,
    \midinote, Pseq([64, 62, 60, 59, 57, 60, 62, 64, 65, 67, 69, 67], 1),
    \dur, Pseq([0.25, 0.25, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1.0], 1),
    \amp, 0.04,
    \pan, -0.6
);

// Voz 6 - pedal grave
~voz6 = Pbind(
    \instrument, \organo6,
    \midinote, Pseq([36, 36, 36, 36, 43, 43, 43, 43, 48, 48, 48, 48], 1),
    \dur, Pseq([1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0], 1),
    \amp, 0.07,
    \pan, 0.6
);

// Iniciar las seis voces en stretto
("=== Fuga a seis voces ===").postln;
("Voz 1: Soprano").postln;
~p1 = ~voz1.play;

1.5.wait;
("Voz 2: Contralto (respuesta)").postln;
~p2 = ~voz2.play;

1.5.wait;
("Voz 3: Tenor").postln;
~p3 = ~voz3.play;

1.5.wait;
("Voz 4: Bajo").postln;
~p4 = ~voz4.play;

1.5.wait;
("Voz 5: Contrasujeto libre").postln;
~p5 = ~voz5.play;

1.5.wait;
("Voz 6: Pedal grave").postln;
~p6 = ~voz6.play;
)

// Para detener todas las voces:
// ~p1.stop; ~p2.stop; ~p3.stop; ~p4.stop; ~p5.stop; ~p6.stop;
#+END_SRC
#+BEGIN_SRC supercollider :results none
// Rameau: bajo fundamental y enlace de acordes
// Traité de l'harmonie, 1722 — SuperCollider, 2026

s.boot;

(
// SynthDef para cada nota del acorde
SynthDef(\rameau, { |out=0, freq=440, amp=0.08, gate=1|
    var sig, env;
    env = EnvGen.kr(Env.asr(0.02, 1, 0.3), gate, doneAction: 2);
    sig = Mix.ar([
        SinOsc.ar(freq, 0, 0.5),
        SinOsc.ar(freq * 2, 0, 0.2),
        SinOsc.ar(freq * 3, 0, 0.1)
    ]);
    sig = sig * env * amp;
    Out.ar(out, sig!2);
}).add;
)

(
// Progresión de acordes según el bajo fundamental
// I (Do mayor) -> V (Sol mayor) -> I (Do mayor)
// Fundamentales: Do -> Sol -> Do (movimiento de quinta)
~progresion_rameau = Routine({
    var acordes = [
        [60, 64, 67],  // Do mayor (C-E-G) - Tónica
        [67, 71, 74],  // Sol mayor (G-B-D) - Dominante
        [60, 64, 67],  // Do mayor (C-E-G) - Tónica
        [60, 65, 69],  // La menor (A-C-E) - Subdominante relativa
        [67, 71, 74],  // Sol mayor (G-B-D) - Dominante
        [60, 64, 67]   // Do mayor (C-E-G) - Tónica
    ];
    var duraciones = [2.0, 1.5, 2.0, 1.5, 1.5, 3.0];

    ("=== Rameau: bajo fundamental ===").postln;
    acordes.do { |notas, i|
        var nombre = switch(i,
            0, {"I — Tónica (Do mayor)"},
            1, {"V — Dominante (Sol mayor)"},
            2, {"I — Tónica (Do mayor)"},
            3, {"vi — Subdominante relativa (La menor)"},
            4, {"V — Dominante (Sol mayor)"},
            5, {"I — Tónica (Do mayor) — cierre"}
        );
        ("→ " ++ nombre).postln;

        // Tocar el acorde: tres notas simultáneas
        notas.do { |midi|
            Synth(\rameau, [\freq, midi.midicps, \amp, 0.06]);
        };

        duraciones[i].wait;
    };
    ("=== El bajo fundamental organiza la armonía ===").postln;
});

~progresion_rameau.play;
)
#+END_SRC
#+BEGIN_SRC supercollider :results none
// Descomposición de Fourier en SuperCollider
// Una onda cuadrada se construye sumando armónicos impares
// Fourier, 1822 — SuperCollider, 2026

(
// Onda cuadrada por síntesis aditiva
SynthDef(\cuadrada_fourier, { |out=0, freq=220, n_arm=1, amp=0.15|
    var sig;
    // Suma de senos: solo armónicos impares con amplitud 1/n
    sig = Mix.ar(
        Array.series(n_arm, 1, 2).collect { |n, i|
            SinOsc.ar(freq * n, 0, 1/n)
        }
    );
    sig = sig * (4/pi) * amp;  // Normalizar como Fourier
    Out.ar(out, sig!2);
}).add;

// Rutina para demostrar la construcción progresiva de la onda
~fourier_demo = Routine({
    var notas = [1, 2, 3, 5, 7, 10, 15, 20, 30, 50];
    ("=== Demostración de Fourier: onda cuadrada por suma de armónicos ===").postln;
    ("Frecuencia fundamental: 220 Hz (La3)").postln;
    notas.do { |n|
        var nombre;
        if(n == 1) { nombre = "Solo fundamental: seno puro" };
        if(n == 2) { nombre = "Fundamental + 3er armónico" };
        if(n > 2) { nombre = "Suma de " ++ n ++ " armónicos impares" };
        ("→ " ++ nombre).postln;
        Synth(\cuadrada_fourier, [\freq, 220, \n_arm, n]);
        2.wait;
    };
    ("=== La onda se aproxima a una cuadrada ===").postln;
});

// Ejecutar
~fourier_demo.play;
)

// Para detener: Cmd + . (o Ctrl + .)
#+END_SRC
#+BEGIN_SRC supercollider :results none
// Laboratorio de Fourier: control de armónicos individuales
// Cada armónico es un parcial que puede activarse/desactivarse
// El timbre resultante es la suma de todos los parciales activos

s.boot;

(
SynthDef(\fourier_lab, { |out=0, freq=220, amp=0.08|
    var sig;
    sig = Mix.ar(16.collect { |i|
        var n = i + 1;
        var active = NamedControl.kr(("arm_" ++ n).asSymbol, 1, 0.02);
        SinOsc.ar(freq * n, 0, 1/n) * active
    });
    sig = sig * amp;
    Out.ar(out, sig!2);
}).add;
)

// Probar con fundamental sola (seno puro)
x = Synth(\fourier_lab, [\freq, 220, \amp, 0.15]);

// Activar armónicos uno a uno
x.set(\arm_2, 1);  // 2do armónico (octava)
x.set(\arm_3, 1);  // 3er armónico (quinta)
x.set(\arm_4, 1);  // 4to armónico (doble octava)
x.set(\arm_5, 1);  // 5to armónico (tercera mayor)

// Apagar la fundamental para escuchar solo armónicos
x.set(\arm_1, 0);

// Volver a encenderla
x.set(\arm_1, 1);

// Activar impares para aproximar onda cuadrada
x.set(\arm_7, 1);
x.set(\arm_9, 1);
x.set(\arm_11, 1);

// Liberar
x.free;
#+END_SRC
#+BEGIN_SRC supercollider :results none
// Schoenberg: serie dodecafónica sonificada
// Pierrot Lunaire, Op. 21 (1912) — SuperCollider, 2026

s.boot;

(
// SynthDef para cada nota de la serie
SynthDef(\serie, { |out=0, freq=440, amp=0.1, gate=1|
    var sig, env;
    env = EnvGen.kr(Env.perc(0.01, 0.8, 1, -4), gate, doneAction: 2);
    sig = SinOsc.ar(freq, 0, amp) * env;
    Out.ar(out, sig!2);
}).add;
)

(
// Rutina: tocar la serie en sus formas original, inversa y retrógrada
~serie_schoenberg = Routine({
    // Serie original P0: Do, Do#, Re, Re#, Mi, Fa, Fa#, Sol, Sol#, La, La#, Si
    var p0 = [60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71];
    // Inversa: espejo alrededor de la primera nota
    var inversa = p0.collect { |n| 60 - (n - 60) };
    // Retrógrada: la serie al revés
    var retrograda = p0.reverse;

    ("=== Schoenberg: serie dodecafónica ===").postln;
    ("Serie original P0").postln;
    p0.do { |n| Synth(\serie, [\freq, n.midicps, \amp, 0.08]); 0.3.wait };
    1.wait;

    ("Serie inversa").postln;
    inversa.do { |n| Synth(\serie, [\freq, n.midicps, \amp, 0.06]); 0.3.wait };
    1.wait;

    ("Serie retrógrada").postln;
    retrograda.do { |n| Synth(\serie, [\freq, n.midicps, \amp, 0.06]); 0.3.wait };
    1.wait;

    ("Las doce notas sin jerarquía. Ninguna subordinada a otra.").postln;
});

~serie_schoenberg.play;
)
#+END_SRC
#+BEGIN_SRC supercollider :results none
// John Cage: 4'33'' (1952)
// Tres movimientos de silencio. La música es lo que suena.

s.boot;

(
~cage_433 = Routine({
    ("=== John Cage: 4'33'' (1952) ===").postln;
    ("Primer movimiento: 33 segundos").postln;
    ("El compositor no controla el sonido.").postln;
    ("Escuche el ambiente. Eso es la música.").postln;
    33.wait;

    ("Segundo movimiento: 2 minutos 40 segundos").postln;
    ("No hay silencio. Siempre hay algo que suena.").postln;
    160.wait;

    ("Tercer movimiento: 1 minuto 20 segundos").postln;
    ("La música no es un objeto: es un proceso.").postln;
    80.wait;

    ("Fin de 4'33''. ¿Escuchó algo?").postln;
});

~cage_433.play;
)
#+END_SRC
#+BEGIN_SRC supercollider :results none
// Música estocástica inspirada en Xenakis
// Control estadístico: el compositor define la distribución,
// el algoritmo genera los eventos individuales
// Xenakis, Metastaseis, 1954

s.boot;

(
// SynthDef: cada "grano" es un evento sonoro independiente
SynthDef(\grano_xenakis, { |out=0, freq=440, amp=0.1, pan=0, duracion=0.1|
    var sig, env;
    env = EnvGen.kr(Env.perc(0.01, duracion, 1, -4), doneAction: 2);
    sig = SinOsc.ar(freq, 0, amp) * env;
    Out.ar(out, Pan2.ar(sig, pan));
}).add;
)

(
// Rutina estocástica: nube de sonidos controlada estadísticamente
~nube_estocastica = Routine({
    var densidad = 20;        // Eventos por segundo (textura)
    var centro_freq = 440;    // Frecuencia central (La4)
    var dispersion = 200;     // Dispersión alrededor del centro
    var duracion_base = 0.15; // Duración base de cada grano

    loop {
        // Frecuencia: distribución gaussiana alrededor del centro
        var freq = centro_freq + (dispersion * rrand(-1.0, 1.0)).gauss(0.5);
        // Amplitud: valores bajos para nubes suaves
        var amp = exprand(0.02, 0.08);
        // Panorámica: distribución espacial aleatoria
        var pan = rrand(-0.8, 0.8);
        // Duración variable de cada grano
        var dur = duracion_base * rrand(0.5, 2.0);

        Synth(\grano_xenakis, [
            \freq, freq.max(50).min(2000),
            \amp, amp,
            \pan, pan,
            \duracion, dur
        ]);

        (1.0 / densidad).wait;  // Control de densidad
    };
});

// Iniciar la nube estocástica
~nube_estocastica.play;
)

// Para detener: Cmd + . (o Ctrl + .)
#+END_SRC
#+BEGIN_SRC supercollider :results none
// Karplus-Strong con sustain (cuerda frotada - violonchelo)
// La excitación es continua, no un pulso

// Liberar memoria y reiniciar servidor
s.freeAll;
s.quit;
s.boot;

(
SynthDef(\ks_comb, { |out=0, freq=220, amp=0.2, decay=3, pan=0|
    var sig, delayTime;
    delayTime = freq.reciprocal;
    sig = WhiteNoise.ar(amp) * EnvGen.kr(Env.perc(0.001, decay), doneAction: 2);
    sig = CombC.ar(sig, 0.5, delayTime, decay);
    sig = LPF.ar(sig, freq * 4 + 100);
    sig = sig * 2;
    Out.ar(out, Pan2.ar(sig, pan));
}).add;
)

// Probar con una nota
x = Synth(\ks_comb, [\freq, 220, \amp, 0.3, \decay, 4]);
x.free;

// Melodía con sustain
~melodia = Pbind(
    \instrument, \ks_comb,
    \midinote, Pseq([48, 52, 55, 60, 64, 67, 72, 67, 64, 60, 55, 52, 48], inf),
    \dur, Pseq([1, 0.5, 0.5, 1, 0.5, 0.5, 2, 0.5, 0.5, 1, 0.5, 0.5, 2], inf),
    \amp, 0.15,
    \decay, 4
).play;

// Detener
~melodia.stop;
#+END_SRC
#+BEGIN_SRC supercollider :results none
// Laboratorio de Fourier: control de armónicos individuales
// Cada armónico es un parcial que puede activarse/desactivarse
// El timbre resultante es la suma de todos los parciales activos

// Liberar memoria y reiniciar servidor
s.freeAll;
s.quit;
s.boot;

(
SynthDef(\fourier_lab, { |out=0, freq=220, amp=0.08|
    var sig;
    sig = Mix.ar(16.collect { |i|
        var n = i + 1;
        var active = NamedControl.kr(("arm_" ++ n).asSymbol, 1, 0.02);
        SinOsc.ar(freq * n, 0, 1/n) * active
    });
    sig = sig * amp;
    Out.ar(out, sig!2);
}).add;
)

// Probar con fundamental sola (seno puro)
x = Synth(\fourier_lab, [\freq, 220, \amp, 0.15]);

// Activar armónicos uno a uno
x.set(\arm_2, 1);  // 2do armónico (octava)
x.set(\arm_3, 1);  // 3er armónico (quinta)
x.set(\arm_4, 1);  // 4to armónico (doble octava)
x.set(\arm_5, 1);  // 5to armónico (tercera mayor)

// Apagar la fundamental para escuchar solo armónicos
x.set(\arm_1, 0);

// Volver a encenderla
x.set(\arm_1, 1);

// Activar impares para aproximar onda cuadrada
x.set(\arm_7, 1);
x.set(\arm_9, 1);
x.set(\arm_11, 1);

// Liberar
x.free;
#+END_SRC
#+BEGIN_SRC supercollider :results none
// Síntesis granular: nubes de partículas sonoras
// Cada grano es una onda sinusoidal microscópica
// La textura emerge de la superposición de miles de granos

// Liberar memoria y reiniciar servidor
s.freeAll;
s.quit;
s.boot;

(
SynthDef(\granular, { |out=0, freq=440, amp=0.1, density=50, spread=0.5|
    var sig, trig, grains;
    // Generar granos a una densidad controlada (granos por segundo)
    trig = Dust.ar(density);
    grains = GrainSin.ar(
        numChannels: 2,
        trigger: trig,
        dur: 0.02,                    // Duración de cada grano: 20 ms
        freq: freq * LFNoise1.kr(3).range(1 - spread, 1 + spread),
        pan: LFNoise1.kr(5).range(-1, 1)
    );
    sig = grains * amp * 0.5;
    Out.ar(out, sig);
}).add;
)

// Probar con diferentes densidades
x = Synth(\granular, [\freq, 220, \amp, 0.15, \density, 20, \spread, 0.1]);
x.set(\density, 100);  // Más granos: textura más densa
x.set(\density, 500);  // Muy denso: casi un sonido continuo
x.set(\density, 10);   // Pocos granos: textura punteada
x.set(\spread, 0.5);   // Más variación de frecuencia
x.set(\freq, 440);     // Cambiar frecuencia base

// Liberar
x.free;

// Evolución de una nube granular
(
~nube = Pbind(
    \instrument, \granular,
    \freq, Pseq([110, 220, 330, 440, 330, 220, 110], inf),
    \dur, 4,
    \density, Pseq([10, 50, 200, 500, 200, 50, 10], inf),
    \spread, Pseq([0.05, 0.1, 0.3, 0.5, 0.3, 0.1, 0.05], inf),
    \amp, 0.1
).play;
)

// Detener
~nube.stop;
#+END_SRC
#+BEGIN_SRC supercollider :results none
// Máquina de Leibniz en SuperCollider (1673)
// La Staffelwalze como sintetizador: cada operación produce un sonido
// "La música es aritmética inconsciente del alma" — Leibniz, 1712

s.boot;

// SynthDef: un tono por cada operación
(
SynthDef(\leibniz_tono, { |out=0, freq=440, amp=0.1, duracion=0.3|
    var sig, env;
    env = EnvGen.kr(Env.perc(0.01, duracion, 1, -4), doneAction: 2);
    sig = SinOsc.ar(freq, 0, amp) * env;
    Out.ar(out, sig!2);
}).add;
)

// Ejecutar la máquina de Leibniz
(
~leibniz_sonoro = Routine({
    var a = 15, b = 27;
    var suma = a + b;
    var resta = a - b;
    var multi = a * b;
    var div = if(b != 0) { a / b } { 0 };

    ("=== Máquina de Leibniz (1673) - Sonora ===").postln;
    ("Entrada: a = " ++ a ++ ", b = " ++ b).postln;

    ("Suma: " ++ a ++ " + " ++ b ++ " = " ++ suma).postln;
    Synth(\leibniz_tono, [\freq, (60 + suma).midicps, \amp, 0.1, \duracion, 0.5]);
    0.6.wait;

    ("Resta: " ++ a ++ " - " ++ b ++ " = " ++ resta).postln;
    Synth(\leibniz_tono, [\freq, (60 + resta.abs).midicps, \amp, 0.08, \duracion, 0.5]);
    0.6.wait;

    ("Multiplicación: " ++ a ++ " × " ++ b ++ " = " ++ multi).postln;
    Synth(\leibniz_tono, [\freq, (60 + (multi % 40)).midicps, \amp, 0.06, \duracion, 0.5]);
    0.6.wait;

    ("División: " ++ a ++ " ÷ " ++ b ++ " = " ++ div).postln;
    Synth(\leibniz_tono, [\freq, (60 + (div * 40).asInteger).midicps, \amp, 0.05, \duracion, 0.5]);
    0.6.wait;

    ("Leibniz: 'La música es aritmética inconsciente del alma'").postln;
});

~leibniz_sonoro.play;
)
#+END_SRC
#+BEGIN_SRC supercollider :results none
// Nueva Complejidad: polirritmia extrema en SuperCollider
// Cinco voces independientes, cada una con su propia lógica temporal
// Inspirado en Ferneyhough: la partitura como campo de fuerzas

s.boot;

(
// SynthDef simple para cada voz
SynthDef(\voz_compleja, { |out=0, freq=440, amp=0.08, gate=1, pan=0|
    var sig, env;
    env = EnvGen.kr(Env.perc(0.01, 0.3, 1, -4), gate, doneAction: 2);
    sig = SinOsc.ar(freq, 0, amp) * env;
    Out.ar(out, Pan2.ar(sig, pan));
}).add;
)

(
// Cinco voces con patrones rítmicos independientes
~complejidad = Routine({
    var voces = 5;
    var patrones = [
        // Voz 1: quintillos (5 notas en espacio de 4)
        Pbind(\instrument, \voz_compleja,
            \midinote, Pseq([72, 74, 76, 77, 79], inf),
            \dur, 0.16, \amp, 0.06, \pan, -0.8),
        // Voz 2: septillos (7 notas en espacio de 4)
        Pbind(\instrument, \voz_compleja,
            \midinote, Pseq([60, 62, 64, 65, 67, 69, 71], inf),
            \dur, 0.114, \amp, 0.05, \pan, -0.4),
        // Voz 3: tresillos (3 notas en espacio de 2)
        Pbind(\instrument, \voz_compleja,
            \midinote, Pseq([48, 52, 55, 60, 64, 67], inf),
            \dur, 0.333, \amp, 0.06, \pan, 0),
        // Voz 4: onceillos (11 notas en espacio de 8)
        Pbind(\instrument, \voz_compleja,
            \midinote, Pseq([67, 65, 64, 62, 60, 59, 57, 55, 53, 52, 50], inf),
            \dur, 0.145, \amp, 0.04, \pan, 0.4),
        // Voz 5: treceavos (13 notas en espacio de 8)
        Pbind(\instrument, \voz_compleja,
            \midinote, Pseq([36, 38, 40, 41, 43, 45, 47, 48, 50, 52, 53, 55, 57], inf),
            \dur, 0.123, \amp, 0.05, \pan, 0.8)
    ];

    ("=== Nueva Complejidad: polirritmia extrema ===").postln;
    ("Cinco voces, cinco lógicas temporales independientes").postln;
    ("Ningún intérprete humano puede ejecutar esto con precisión").postln;

    // Iniciar todas las voces
    patrones.do { |patron, i|
        ("Voz " ++ (i+1) ++ " iniciada").postln;
        patron.play;
    };

    30.wait;  // Dejar sonar durante 30 segundos

    ("La partitura como campo de fuerzas: imposible, pero real.").postln;
});

~complejidad.play;
)

// Para detener: Cmd + . (o Ctrl + .)
#+END_SRC
