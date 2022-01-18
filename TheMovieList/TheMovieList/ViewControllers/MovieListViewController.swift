//
//  MovieListViewController.swift
//  TheMovieList
//
//  Created by  Paul on 14.01.2022.
//

import UIKit

final class MovieListViewController: UITableViewController {
    
    // MARK: - Private vars
    
    private var diffableDataSource: UITableViewDiffableDataSource<Section, Movie>!
    private lazy var activityIndicator: UIActivityIndicatorView = {
        $0.hidesWhenStopped = true
        $0.center = self.view.center
        self.view.addSubview($0)
        return $0
    }(UIActivityIndicatorView(style: .large))
    
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        setupTableView()
        fetchMovies2()
    }
    
    // MARK: - Private funcs
    
    private func fetchMovies() {
        activityIndicator.startAnimating()
        MovieStore.shared.fetchMovies(from: .upcoming) { [weak self] result in
            switch result {
            case .success(let movieResponse):
                self?.generateSnapshot(with: movieResponse.results)
            case .failure(let error):
                self?.handleError(apiError: error)
            }
            self?.activityIndicator.stopAnimating()
        }
    }
    
    private func fetchMovies2() {
        activityIndicator.startAnimating()
        guard let url = MovieStore.shared.generateURL(with: .upcoming) else { return }
        Task(priority: .background) { 
            let movieResponse: MoviesResponse? = try? await MovieStore.shared.fetchAndDecode(url: url)
            if let movieResponse = movieResponse {
                generateSnapshot(with: movieResponse.results)
                activityIndicator.stopAnimating()
            }
        }
        
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorInset = .zero
        tableView.allowsSelection = false
        diffableDataSource = UITableViewDiffableDataSource<Section, Movie>(tableView: tableView) { (tableView, indexPath, movie) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.configure(with: movie)
            return cell
        }
    }
    
    private func generateSnapshot(with movies: [Movie]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func handleError(apiError: Error) {
        let alertController = UIAlertController(title: "Error", message: apiError.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true)
    }
}

fileprivate enum Section {
    case main
}

private extension UITableViewCell {
    // TODO: refactor to unblocking
    func configure(with movie: Movie) {
        var configuration = defaultContentConfiguration()
        configuration.text = movie.title
        configuration.secondaryText = movie.overview
        configuration.imageProperties.cornerRadius = 5
        configuration.imageProperties.reservedLayoutSize = CGSize(width: 100, height: 100) //UIListContentConfiguration.ImageProperties.standardDimension
        configuration.imageProperties.maximumSize = CGSize(width: 100, height: 100)
        //configuration.imageProperties.preferredSymbolConfiguration = .init(scale: .large)
        configuration.image = UIImage(systemName: "photo")
        contentConfiguration = configuration
        guard let posterURL = movie.posterURL else { return }
        MovieStore.shared.fetchData(url: posterURL) { [weak self] data in
            configuration.image = UIImage(data: data)
            //configuration.secondaryText = movie.overview
            print("Fetched \(posterURL)")
            sleep(1)
            DispatchQueue.main.async {
            self?.contentConfiguration = configuration
            }
            // self?.setNeedsUpdateConfiguration()
        }
    }
}

