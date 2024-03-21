// import java.io.File;

// import javax.sound.midi.MidiEvent;
// import javax.sound.midi.MidiMessage;
// import javax.sound.midi.MidiSystem;
// import javax.sound.midi.Sequence;
// import javax.sound.midi.ShortMessage;
// import javax.sound.midi.Track;

// public class MidiVisualPlayer {
//     public static final int NOTE_ON_CODE = 0x90;
//     public static final int NOTE_OFF_CODE = 0x80;
//     public final String[] NOTE_NAMES = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};

//     String[] notes;
//     int[] keys;
//     int[] ticks;
//     int[] velocity;

//     public MidiVisualPlayer() {
//         notes = new String[0];
//         keys = new int[0];
//         ticks = new int[0];
//         velocity = new int[0];
//     }


//     public satic void main(String[] args) throws Exception {
//         Sequence sequence = MidiSystem.getSequence(new File("test.mid"));

//         int trackNumber = 0;

//         for (Track track :  sequence.getTracks()) {
//             trackNumber++;
//             System.out.println("Track " + trackNumber + ": size = " + track.size());
//             System.out.println();
//             for (int i=0; i < track.size(); i++) { 
//                 MidiEvent event = track.get(i);
//                 System.out.print("@" + event.getTick() + " ");
//                 MidiMessage message = event.getMessage();
//                 if (message instanceof ShortMessage) {
//                     ShortMessage sm = (ShortMessage) message;
//                     System.out.print("Channel: " + sm.getChannel() + " ");
//                     if (sm.getCommand() == NOTE_ON_CODE) {
//                         int key = sm.getData1();
//                         int octave = (key / 12)-1;
//                         int note = key % 12;
//                         String noteName = NOTE_NAMES[note];
//                         int velocity = sm.getData2();
//                         System.out.println("Note on, " + noteName + octave + " key=" + key + " velocity: " + velocity);
//                     } else if (sm.getCommand() == NOTE_OFF_CODE) {
//                         int key = sm.getData1();
//                         int octave = (key / 12)-1;
//                         int note = key % 12;
//                         String noteName = NOTE_NAMES[note];
//                         int velocity = sm.getData2();
//                         System.out.println("Note off, " + noteName + octave + " key=" + key + " velocity: " + velocity);
//                     } else {
//                         System.out.println("Command:" + sm.getCommand());
//                     }
//                 } else {
//                     System.out.println("Other message: " + message.getClass());
//                 }
//             }

//             System.out.println();
//         }

//     }
// }