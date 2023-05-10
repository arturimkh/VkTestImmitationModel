import UIKit

struct TileModel{
    var isSick: Bool = false
}
class NodeMap : UICollectionViewController {
    var rows = 20
    var cols = 20
    var infectionGroup = 2
    var time: Double = 0.5
    var amountOfSick = 0

    var tilesSick = Set<IndexPath>()
    var indexPath: IndexPath?
    var tiles: [[TileModel]] = Array (repeating: Array(repeating: TileModel(), count : 10000), count : 10000)
    var flag = false
    override func viewDidLoad(){
        collectionView.register(HorizontalTagCollectionViewCell.self, forCellWithReuseIdentifier: "node")
        self.collectionView!.collectionViewLayout = NodeLayout(itemWidth: 50, itemHeight: 50, space: 5.0)
       //collectionView.prefetchDataSource = self
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rows
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cols
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "node", for: indexPath) as? HorizontalTagCollectionViewCell else {return UICollectionViewCell()}
            let tile = tiles[indexPath.row][indexPath.section]
            switch tile.isSick{
            case true:
                cell.backgroundColor = .red
                _ = Timer.scheduledTimer(withTimeInterval: time, repeats: false) { a in
                  self.updateSickPeople(indexPath)
                }
            case false:
                cell.backgroundColor = .white
            }
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
//        var tile = TileModel()
//        tile.isSick = true
//        tiles[indexPath.row][indexPath.section] = tile
        updateSickPeople(indexPath)
        collectionView.reloadData()
    }
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        for indexPath in indexPaths{
//            if let cell = collectionView.cellForItem(at: indexPath) as? HorizontalTagCollectionViewCell {
//                if tiles[indexPath.row][indexPath.section].isSick{
//                    cell.backgroundColor = .red
//                } else {
//                    cell.backgroundColor = .white
//                }
//            }
//        }
//    }

    func updateSickPeople(_ indexPath: IndexPath){
//        var flag = false
//        for i in 0..<self.rows{
//            for j in 0..<self.cols{
//                if (tiles[i][j].isSick == false){
//                    flag = true
//                    break
//                }
//            }
//        }
//        if flag{
//            DispatchQueue.main.asyncAfter(deadline: .now() + time){ [self] in
//            var tile = TileModel()
//            tile.isSick = true
//            self.tiles[indexPath.row+1][indexPath.section] = tile
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
            //}
//            DispatchQueue.global().async {
//                // Step 1: Identify the cells to update
//                let indexPathsToUpdate = [IndexPath(item: indexPath.item + 1, section: indexPath.section)]
//                // Step 2: Update the underlying data source
//                for indexPath in indexPathsToUpdate{
//                    var tile = TileModel()
//                    tile.isSick = true
//                    self.tiles[indexPath.row][indexPath.section] = tile
//                    print(indexPath)
//                }
//                DispatchQueue.main.async {
//                    self.collectionView.reloadItems(at: indexPathsToUpdate)
//                }
//            }
            tilesSick.insert(indexPath)
            for _ in 0..<amountOfSick + 1{
                if tilesSick.isEmpty{
                    break
                }
                let rand = Int.random(in: 1...tilesSick.count)
                var j = 1
                for tile in tilesSick{
                    if j == rand {
                        if ((tile.row + 1 < rows) && (tiles[tile.row + 1][tile.section].isSick == false)) {
                            tilesSick.insert(IndexPath(row: tile.row + 1, section: tile.section))
                        }
                        if ((tile.section + 1 < cols) && (tiles[tile.row][tile.section + 1].isSick == false)){
                            tilesSick.insert(IndexPath(row: tile.row, section: tile.section + 1))
                        }
                        if ((tile.row - 1 >= 0) && (tiles[tile.row-1][tile.section].isSick == false)){
                            tilesSick.insert(IndexPath(row: tile.row-1, section: tile.section))
                        }
                        if ((tile.section - 1 >= 0) && (tiles[tile.row][tile.section-1].isSick == false)){
                            tilesSick.insert(IndexPath(row: tile.row, section: tile.section-1))
                        }
                        var tile2 = TileModel()
                        tile2.isSick = true
                        self.tiles[tile.row][tile.section] = tile2
                        tilesSick.remove(tile)
                        break
                    }
                    j += 1
                }
            }
        tilesSick.removeAll()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
//        } else {
//            print("все были зараженны")
//        }
    }
}
class NodeLayout : UICollectionViewFlowLayout {
    var itemWidth : CGFloat
    var itemHeight : CGFloat
    var space : CGFloat
    var columns: Int{
        return self.collectionView!.numberOfItems(inSection: 0)
    }
    var rows: Int{
        return self.collectionView!.numberOfSections
    }

    init(itemWidth: CGFloat, itemHeight: CGFloat, space: CGFloat) {
        self.itemWidth = itemWidth
        self.itemHeight = itemHeight
        self.space = space
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        self.itemWidth = 50
        self.itemHeight = 50
        self.space = 3
        super.init()
    }

    override var collectionViewContentSize: CGSize{
        let w : CGFloat = CGFloat(columns) * (itemWidth + space)
        let h : CGFloat = CGFloat(rows) * (itemHeight + space)
        return CGSize(width: w, height: h)
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let x : CGFloat = CGFloat(indexPath.row) * (itemWidth + space)
        let y : CGFloat = CGFloat(indexPath.section) + CGFloat(indexPath.section) * (itemHeight + space)
        attributes.frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
        return attributes
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let minRow : Int = (rect.origin.x > 0) ? Int(floor(rect.origin.x/(itemWidth + space))) : 0
        let maxRow : Int = min(columns - 1, Int(ceil(rect.size.width / (itemWidth + space)) + CGFloat(minRow)))
        var attributes : Array<UICollectionViewLayoutAttributes> = [UICollectionViewLayoutAttributes]()
        for i in 0 ..< rows {
            for j in minRow ... maxRow {
                attributes.append(self.layoutAttributesForItem(at: IndexPath(item: j, section: i))!)
            }
        }
        return attributes
    }
}
class HorizontalTagCollectionViewCell: UICollectionViewCell {
    let nameCategoryLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .center
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 15)
        return $0
    }(UILabel())
//        override var isSelected: Bool{
//            didSet{
//                backgroundColor = self.isSelected ? .red : .blue
//            }
//        }
    var isSick1 = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupViews(){
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        addSubview(nameCategoryLabel)
    }
    private func setConstraints(){
        NSLayoutConstraint.activate([
            nameCategoryLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameCategoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
