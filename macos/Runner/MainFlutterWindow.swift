import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController

    // Розмір вікна відповідно до макетів (ЛР2) і мінімальний розмір.
    self.setContentSize(NSSize(width: 1200, height: 780))
    self.contentMinSize = NSSize(width: 900, height: 600)
    self.title = "Поштовий трекер"
    self.center()

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
