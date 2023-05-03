import Sentry

struct Monitoring {
  
    static var logger: SentryHub!
  
  static func start() {
    let options = Options()
      options.dsn = "https://8be72ce2c6f54fb989fac72f82a1a628@o4505121822801920.ingest.sentry.io/4505121826209792"
      options.debug = true
      let client = SentryClient(options: options)
      logger = SentryHub(client: client, andScope: nil)
  }
  
  static func error(_ e: Error) {
      logger.capture(error: e)
  }
}
