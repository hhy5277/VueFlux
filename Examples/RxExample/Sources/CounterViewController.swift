import UIKit
import VueFlux
import GenericComponents
import RxSwift
import RxCocoa

final class CounterViewController: UIViewController {
    @IBOutlet private weak var counterView: CounterView!
    
    private let store = Store<CounterState>(state: .init(max: 1000), mutations: .init(), executor: .queue(.global()))
    private let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension CounterViewController {
    func configure() {
        counterView.incrementButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] _ in
                self.store.actions.incrementAcync(after: self.counterView.interval)
            })
            .disposed(by: disposeBag)
        
        counterView.decrementButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] _ in
                self.store.actions.decrementAcync(after: self.counterView.interval)
            })
            .disposed(by: disposeBag)
        
        counterView.resetButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] _ in
                self.store.actions.resetAcync(after: self.counterView.interval)
            })
            .disposed(by: disposeBag)
        
        store.computed.count
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] count in
                self.counterView.count = count
            })
            .disposed(by: disposeBag)
    }
}
