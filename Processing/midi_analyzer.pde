public class MidiSequenceAnalyzer {
    private double bpm;
    private long quarterNoteDurationMs;
    private float tickMs;

    public MidiSequenceAnalyzer() {}
    public MidiSequenceAnalyzer(Sequence sequence) {
        this.analyze(sequence);
    }

    // Method to analyze the sequence and calculate BPM and quarter note duration
    public void analyze(Sequence sequence) {
        this.bpm = calculateBPM(sequence);
        this.quarterNoteDurationMs = calculateQuarterNoteDurationMs(sequence, bpm);
        this.tickMs = calculateTickLength(sequence);
    }

    // Method to calculate BPM (Beats Per Minute)
    private double calculateBPM(Sequence sequence) {
        double microsecondsPerQuarterNote = sequence.getMicrosecondLength();
        double t = 60000000 / microsecondsPerQuarterNote;
        return 600 * t; // 60,000,000 microseconds in a minute
    }

        // Method to calculate BPM (Beats Per Minute)
    private float calculateTickLength(Sequence sequence) {
        double microseconds = sequence.getMicrosecondLength();
        double ticks = sequence.getTickLength();
        this.tickMs = (float) (microseconds / ticks);
        return this.tickMs; // 60,000,000 microseconds in a minute
    }

    // Method to calculate the duration of a quarter note in milliseconds
    private long calculateQuarterNoteDurationMs(Sequence sequence, double bpm) {
        // Assuming 4/4 time signature, one quarter note lasts for one beat
        double secondsPerQuarterNote = 60 / bpm; // 60 seconds in a minute
        return (long) (secondsPerQuarterNote * 1000); // Convert seconds to milliseconds
    }

    // Getter for BPM
    public double getBPM() {
        return bpm;
    }

    // Getter for tick duration in milliseconds
    public float getTickMs() {
        return tickMs;
    } 

    // Getter for quarter note duration in milliseconds
    public long getQuarterNoteDurationMs() {
        return quarterNoteDurationMs;
    }
}