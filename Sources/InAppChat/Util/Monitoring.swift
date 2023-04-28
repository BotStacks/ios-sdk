
import RollbarNotifier
import RollbarPLCrashReporter

struct Monitoring {
  
  static var logger: RollbarLogger!
  
  static func start() {
    self.logger = RollbarLogger(accessToken: "f7bb611f09d741c0b77d1032a1a2d71c")
    let collector = RollbarPLCrashCollector()
    collector.collectCrashReports(with: CrashReporter())
  }
  
  static func error(_ e: Error) {
    return logger.log(.error, error: e, data: nil, context: nil)
  }
}

private class CrashReporter: RollbarCrashCollectorObserver {
  func onCrashReportsCollectionCompletion(_ crashReports: [RollbarCrashReportData]!) {
    for report in crashReports {
      Monitoring.logger.logCrashReport(report.crashReport)
    }
  }
}
