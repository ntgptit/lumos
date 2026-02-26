package com.lumos.common.error;

public abstract class BaseApiException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    private final String messageKey;
    private final transient Object[] messageArgs;

    protected BaseApiException(String messageKey, Object... messageArgs) {
        super(messageKey);
        this.messageKey = messageKey;
        this.messageArgs = messageArgs;
    }

    public String getMessageKey() {
        return messageKey;
    }

    public Object[] getMessageArgs() {
        return messageArgs;
    }
}
