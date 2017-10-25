
  Mail.register_interceptor RecipientInterceptor.new(Settings.email.sandbox, subject_prefix: '[STAGING]')