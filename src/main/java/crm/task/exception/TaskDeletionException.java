package crm.task.exception;

public class TaskDeletionException extends RuntimeException {
    public TaskDeletionException(String message, Throwable cause) {
        super(message, cause);
    }
}