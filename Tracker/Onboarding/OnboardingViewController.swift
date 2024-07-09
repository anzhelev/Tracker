//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Andrey Zhelev on 08.07.2024.
//
import UIKit

final class OnboardingViewController: UIPageViewController {
    
    private let labels = [
        ["Отслеживайте только", "то, что хотите"],
        ["Даже если это", "не литры воды и йога"]
    ]
    
    private lazy var pages: [UIViewController] = {
        
        var firstView: UIViewController {
            var vc = UIViewController()
            if let image = UIImage(named: "onboardingBG 1") {
                let bgView = UIImageView(image: image)
                vc.view = bgView
            }
            setlabels(on: vc, with: labels[0])
            setButtonView(on: vc)
            
            return vc
        }
        
        var secondView: UIViewController {
            var vc = UIViewController()
            if let image = UIImage(named: "onboardingBG 2") {
                let bgView = UIImageView(image: image)
                vc.view = bgView
            }
            setlabels(on: vc, with: labels[1])
            setButtonView(on: vc)
            
            return vc
        }
        
        return [firstView, secondView]
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = Colors.black
        pageControl.pageIndicatorTintColor = Colors.black.withAlphaComponent(0.3)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        setPageControl()
        setButton(on: self)
    }
    
    @objc private func welcomeButtonButtonPressed() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        window.rootViewController = TabBarController()
    }
    
    private func setButtonView(on vc: UIViewController) {
        let buttonView = UILabel()
        buttonView.backgroundColor = Colors.black
        buttonView.text = "Вот это технологии!"
        buttonView.font = Fonts.SFPro16Semibold
        buttonView.textColor = Colors.white
        buttonView.textAlignment = .center
        setPosition(for: buttonView, on: vc)
    }
    
    private func setButton(on vc: UIViewController) {
        let button = UIButton()
        button.addTarget(self, action: #selector(self.welcomeButtonButtonPressed), for: .touchUpInside)
        button.backgroundColor = .none
        setPosition(for: button, on: vc)
    }
    
    private func setPosition(for button: UIView, on vc: UIViewController) {
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 60),
            button.bottomAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            button.leadingAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func setPageControl() {
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setlabels(on vc: UIViewController, with labels: [String]) {
        
        let label1 = UILabel()
        label1.text = labels[0]
        label1.font = Fonts.SFPro32Bold
        label1.textColor = Colors.black
        label1.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(label1)
        
        let label2 = UILabel()
        label2.text = labels[1]
        label2.font = Fonts.SFPro32Bold
        label2.textColor = Colors.black
        label2.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(label2)
        
        NSLayoutConstraint.activate([
            label1.heightAnchor.constraint(equalToConstant: 38),
            label1.topAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.centerYAnchor, constant: 15),
            label1.centerXAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.centerXAnchor),
            label2.heightAnchor.constraint(equalTo: label1.heightAnchor),
            label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 0),
            label2.centerXAnchor.constraint(equalTo: label1.centerXAnchor)
        ])
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return pages.last
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return pages.first
        }
        
        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
