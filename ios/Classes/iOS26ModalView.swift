import Flutter
import UIKit



class iOS26ModalViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return iOS26ModalView(frame: frame, viewIdentifier: viewId, arguments: args, binaryMessenger: messenger)
    }

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}


class iOS26ModalView: NSObject, FlutterPlatformView {
    private var _view: UIView
    private var blurEffectView: UIVisualEffectView!
    private var channel: FlutterMethodChannel
    private var modalId: Int

    // Default iOS 26 "Liquid" Specs
    private var cornerRadius: CGFloat = 32.0
    private var blurStyle: UIBlurEffect.Style = .systemUltraThinMaterial
    private var opacity: CGFloat = 1.0

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        _view = UIView(frame: frame)

        // 1. Extract config (Same logic as your slider)
        if let config = args as? [String: Any] {
            modalId = config["id"] as? Int ?? 0
            cornerRadius = CGFloat(config["cornerRadius"] as? Double ?? 32.0)
            
            if let isDark = config["isDark"] as? Bool {
                blurStyle = isDark ? .systemMaterialDark : .systemUltraThinMaterial
            }
        } else {
            modalId = 0
        }

        // 2. Setup channel following your slider's naming convention
        channel = FlutterMethodChannel(
            name: "adaptive_platform_ui/ios26_modal_\(modalId)",
            binaryMessenger: messenger
        )

        super.init()

        // 3. Create the Glass UI
        setupGlassEffect()

        // 4. Handle incoming updates from Flutter
        channel.setMethodCallHandler { [weak self] (call, result) in
            self?.handleMethodCall(call, result: result)
        }
    }

    private func setupGlassEffect() {
        _view.backgroundColor = .clear
        
        // Create Blur
        let blurEffect = UIBlurEffect(style: blurStyle)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        // Apply iOS 26 styling
        blurEffectView.layer.cornerRadius = cornerRadius
        blurEffectView.layer.masksToBounds = true
        
        // Add "Liquid Edge" (Subtle white border)
        blurEffectView.layer.borderWidth = 0.5
        blurEffectView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor

        _view.addSubview(blurEffectView)

        // Constraints to fill the Flutter container
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: _view.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: _view.bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: _view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: _view.trailingAnchor)
        ])
    }

    private func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "setStyle":
            if let args = call.arguments as? [String: Any],
               let isDark = args["isDark"] as? Bool {
                blurStyle = isDark ? .systemMaterialDark : .systemUltraThinMaterial
                blurEffectView.effect = UIBlurEffect(style: blurStyle)
            }
            result(nil)

        case "setCornerRadius":
            if let args = call.arguments as? [String: Any],
               let radius = args["radius"] as? Double {
                cornerRadius = CGFloat(radius)
                blurEffectView.layer.cornerRadius = cornerRadius
            }
            result(nil)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func view() -> UIView {
        return _view
    }
}