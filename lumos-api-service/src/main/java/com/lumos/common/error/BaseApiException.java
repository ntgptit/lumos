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
        // Return the i18n message key that the global exception handler resolves for the client payload.
        return messageKey;
    }

    public Object[] getMessageArgs() {
        // Return the interpolation arguments used to render the localized error message.
        return messageArgs;
    }
}
