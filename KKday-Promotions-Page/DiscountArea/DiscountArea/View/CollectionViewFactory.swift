
import UIKit

enum PromoLayoutType {
    case tabRow
    case tabGrid
    case row
    case grid
}

class CollectionViewFactory {
    
    var scrollCallback: (([NSCollectionLayoutVisibleItem],CGPoint) -> Void)?

    func createLayout(for dataType: PromoLayoutType) -> UICollectionViewCompositionalLayout {
        switch dataType {
        case .tabRow:
            return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
                if sectionIndex == 0 {
                    return self.tabRowLayout()
                } else {
                    return self.rowLayout()
                }
            }

        case .tabGrid:
            return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
                if sectionIndex == 0 {
                    return self.tabRowLayout()
                } else {
                    return self.gridLayout()
                }
            }

        case .row:
            return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
                return self.rowLayout()
            }

        case .grid:
            return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
                return self.gridLayout()
            }
        }
    }

    func tabRowLayout() -> NSCollectionLayoutSection {
        let itemWidth = NSCollectionLayoutDimension.estimated(500)
        let itemSize = NSCollectionLayoutSize(widthDimension: itemWidth, heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: itemWidth, heightDimension: .absolute(32))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)
        
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, point, environment in
            self?.scrollCallback?(visibleItems, point)
        }

        return section
    }
    
    func gridLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(250))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(12)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 24, bottom: 20, trailing: 24)
        
        return section
    }
    
    func rowLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(148), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(12)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 24, bottom: 20, trailing: 24)
        
        return section
    }
}
