public class GameNote {
    private int code;
    private long ticksDuration;
    private long tickTimestamp;
    private int timestampMs;
    private int durationMs;
    private int velocity;

    public GameNote() {
        this.code = 0;
        this.tickTimestamp = 0;
        this.ticksDuration = 0;
        this.velocity = 0;
        this.durationMs = 0;
        this.timestampMs = 0;   
        
    }

    public GameNote(int code, long tickTimestamp, int velocity) {
        this.code = code;
        this.tickTimestamp = tickTimestamp;
        this.ticksDuration = 0;
        this.velocity = velocity;
        this.durationMs = 0;   
        this.timestampMs = 0;    
    }

    public GameNote(int code, long tickTimestamp, float tick2Ms, int velocity) {
        this.code = code;
        this.tickTimestamp = tickTimestamp;
        this.ticksDuration = ticksDuration;
        this.velocity = velocity;
        this.durationMs = Math.round(ticksDuration * tick2Ms);
        this.timestampMs = Math.round(tickTimestamp * tick2Ms);    
    }

    public GameNote(int code, long tickTimestamp, int ticksDuration, int velocity, float tick2Ms) {
        this.code = code;
        this.tickTimestamp = tickTimestamp;
        this.ticksDuration = ticksDuration;
        this.velocity = velocity;
        this.durationMs = Math.round(ticksDuration * tick2Ms);
        this.timestampMs = Math.round(tickTimestamp * tick2Ms);    
    }

    
    // Getter for code
    public int getCode() {
        return code;
    }

    // Setter for code
    public void setCode(int code) {
        this.code = code;
    }

    // Getter for ticksDuration
    public long getTicksDuration() {
        return ticksDuration;
    }

    // Setter for ticksDuration
    public void setTicksDuration(long ticksDuration) {
        this.ticksDuration = ticksDuration;
    }

    // Getter for tickTimestamp
    public long getTickTimestamp() {
        return tickTimestamp;
    }

    // Setter for tickTimestamp
    public void setTickTimestamp(long tickTimestamp) {
        this.tickTimestamp = tickTimestamp;
    }

    // Getter for velocity
    public int getVelocity() {
        return velocity;
    }

    // Setter for velocity
    public void setVelocity(int velocity) {
        this.velocity = velocity;
    }

    // Getter for timestampMs
    public int getTimestampMs() {
        return timestampMs;
    }

    // Setter for timestampMs
    public void setTimestampMs(int timestampMs) {
        this.timestampMs = timestampMs;
    }

    // Getter for durationMs
    public int getDurationMs() {
        return durationMs;
    }

    // Setter for durationMs
    public void setDurationMs(int durationMs) {
        this.durationMs = durationMs;
    }

    public int[] getOneHotNoteCode() {
        int[] oneHotNote = new int[36];
        oneHotNote[this.code % 36] = 1;
        return oneHotNote;
    }
}
