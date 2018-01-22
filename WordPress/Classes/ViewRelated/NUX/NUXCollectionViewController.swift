// MARK: - NUXCollectionViewController
/// Base class to use for NUX view controllers that are also a table view controller
/// Note: shares most of its code with NUXViewController and NUXTableViewController.
class NUXCollectionViewController: UICollectionViewController, NUXViewControllerBase, UIViewControllerTransitioningDelegate {
    // MARK: NUXViewControllerBase properties
    /// these properties comply with NUXViewControllerBase and are duplicated with NUXTableViewController
    var helpBadge: WPNUXHelpBadgeLabel = WPNUXHelpBadgeLabel()
    var helpButton: UIButton = UIButton(type: .custom)
    var dismissBlock: ((_ cancelled: Bool) -> Void)?
    var loginFields = LoginFields()
    var sourceTag: SupportSourceTag {
        get {
            return .generalLogin
        }
    }

    override func viewDidLoad() {
        addHelpButtonToNavController()
        setupCancelButtonIfNeeded()
    }

    func shouldShowCancelButton() -> Bool {
        return shouldShowCancelButtonBase()
    }
}
