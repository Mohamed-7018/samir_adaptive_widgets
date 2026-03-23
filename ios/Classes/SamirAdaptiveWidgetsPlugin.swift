import Flutter
import UIKit

/// Main plugin class for Adaptive Platform UI
/// Registers platform views and handles plugin lifecycle
public class SamirAdaptiveWidgetsPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
       // ✅ Method Channel
        let channel = FlutterMethodChannel(
            name: "adaptive_platform_ui",
            binaryMessenger: registrar.messenger()
        )

        let instance = SamirAdaptiveWidgetsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

        // Initialize iOS 26+ Native Tab Bar Manager
        if #available(iOS 26.0, *) {
            iOS26NativeTabBarManager.shared.setup(messenger: registrar.messenger())
        }

        // Register iOS 26 Button platform view factory
        let ios26ButtonFactory = iOS26ButtonViewFactory(messenger: registrar.messenger())
        registrar.register(
            ios26ButtonFactory,
            withId: "adaptive_platform_ui/ios26_button"
        )

        // Register iOS 26 Switch platform view factory
        let ios26SwitchFactory = iOS26SwitchViewFactory(messenger: registrar.messenger())
        registrar.register(
            ios26SwitchFactory,
            withId: "adaptive_platform_ui/ios26_switch"
        )

        // Register iOS 26 Slider platform view factory
        let ios26SliderFactory = iOS26SliderViewFactory(messenger: registrar.messenger())
        registrar.register(
            ios26SliderFactory,
            withId: "adaptive_platform_ui/ios26_slider"
        )

        // Register iOS 26 SegmentedControl platform view factory
        let ios26SegmentedControlFactory = iOS26SegmentedControlViewFactory(messenger: registrar.messenger())
        registrar.register(
            ios26SegmentedControlFactory,
            withId: "adaptive_platform_ui/ios26_segmented_control"
        )

        // Register iOS 26 AlertDialog platform view factory
        let ios26AlertDialogFactory = iOS26AlertDialogViewFactory(messenger: registrar.messenger())
        registrar.register(
            ios26AlertDialogFactory,
            withId: "adaptive_platform_ui/ios26_alert_dialog"
        )

        // Register iOS 26 PopupMenuButton platform view factory
        let ios26PopupMenuButtonFactory = iOS26PopupMenuButtonViewFactory(messenger: registrar.messenger())
        registrar.register(
            ios26PopupMenuButtonFactory,
            withId: "adaptive_platform_ui/ios26_popup_menu_button"
        )

        // Register iOS 26 TabBar platform view factory
        let ios26TabBarFactory = iOS26TabBarViewFactory(messenger: registrar.messenger())
        registrar.register(
            ios26TabBarFactory,
            withId: "adaptive_platform_ui/ios26_tab_bar"
        )

        // Register iOS 26 Toolbar platform view factory
        let ios26ToolbarFactory = iOS26ToolbarFactory(messenger: registrar.messenger())
        registrar.register(
            ios26ToolbarFactory,
            withId: "adaptive_platform_ui/ios26_toolbar"
        )

        // Register iOS 26 Blur View platform view factory
        let ios26BlurViewFactory = iOS26BlurViewFactory(messenger: registrar.messenger())
        registrar.register(
            ios26BlurViewFactory,
            withId: "adaptive_platform_ui/ios26_blur_view"
        )

        // Register iOS 26 Modal platform view factory
        let ios26ModalFactory = iOS26ModalViewFactory(messenger: registrar.messenger())
        registrar.register(
            ios26ModalFactory,
            withId: "adaptive_platform_ui/ios26_modal"
        )
    }
}

extension SamirAdaptiveWidgetsPlugin {

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

        switch call.method {

        case "showNativeModal":
            guard let args = call.arguments as? [String: Any] else {
                result(FlutterError(
                    code: "INVALID_ARGS",
                    message: "Arguments missing",
                    details: nil
                ))
                return
            }

            let enableBlur = args["enableBlur"] as? Bool ?? true
            let isDismissible = args["isDismissible"] as? Bool ?? true

            DispatchQueue.main.async {
                self.presentNativeModal(
                    enableBlur: enableBlur,
                    isDismissible: isDismissible
                )
            }

            result(nil)

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
extension SamirAdaptiveWidgetsPlugin {

    func presentNativeModal(enableBlur: Bool, isDismissible: Bool) {

        guard let windowScene = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first,
              let rootVC = windowScene.windows
                .first(where: { $0.isKeyWindow })?
                .rootViewController
        else {
            return
        }

        let modalVC = UIViewController()
        modalVC.view.backgroundColor = .clear

        if enableBlur {
            let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = modalVC.view.bounds
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            modalVC.view.addSubview(blurView)
        }

        modalVC.modalPresentationStyle = .pageSheet

        if let sheet = modalVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 32
            if !isDismissible {
                sheet.largestUndimmedDetentIdentifier = .medium
            }
        }

        rootVC.present(modalVC, animated: true)
    }
}
