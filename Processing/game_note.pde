public class GameNote {
    private int code;
    private int duration;
    private long timestamp;

    public GameNote() {
        this.code = 0;
        this.duration = 0;
        this.timestamp = 0;
    }

    public GameNote(int code, int duration, long timestamp) {
        this.code = code;
        this.duration = duration;
        this.timestamp = timestamp;
    }

    // Getter for code
    public int getCode() {
        return code;
    }

    // Setter for code
    public void setCode(int code) {
        this.code = code;
    }

    // Getter for duration
    public int getDuration() {
        return duration;
    }

    // Setter for duration
    public void setDuration(int duration) {
        this.duration = duration;
    }

    // Getter for timestamp
    public long getTimestamp() {
        return timestamp;
    }

    // Setter for timestamp
    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }
}