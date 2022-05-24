# Marvel Characters

A cool app to explore the marvel heroes universe

## About the app

The app lists all the marvel universe characters. The user can see a paginated list of characters, showing more characters when the user scrolls to the bottom of the list. Also, the user can search for a specific character by typing the name of the character. The user can see the a detailed description of the character by tapping the character cell in the list.
The app is an universal app (iPhone and iPad), it supports portrait and landscape, and it supports light and dark mode.

### Screenshots

![Simulator Screen Shot - iPhone 12 Pro Max - 2022-05-24 at 00 32 30](https://user-images.githubusercontent.com/5033596/169944290-c8c2a058-71a4-46b2-8f8f-e431f8a1674f.png)
![Simulator Screen Shot - iPhone 12 Pro Max - 2022-05-24 at 00 32 55](https://user-images.githubusercontent.com/5033596/169944479-d3fffb8d-4918-42fe-8012-bd943f771950.png)
![Simulator Screen Shot - iPhone 12 Pro Max - 2022-05-24 at 00 33 28](https://user-images.githubusercontent.com/5033596/169944489-45bd7803-b8d7-453c-84e1-c1a7493a7cf5.png)
![Simulator Screen Shot - iPhone 12 Pro Max - 2022-05-24 at 00 33 32](https://user-images.githubusercontent.com/5033596/169944493-f2cae082-a68c-43e9-a805-25ddead287a4.png)

(there are more screenshots in the screenshots folder)

## How is the app built

### UI

The main UI of the application is a collecction view. This app showcases the use of [UICollectionViewCompositionalLayout](https://developer.apple.com/documentation/uikit/uicollectionviewcompositionallayout) and [UITableViewDiffableDataSource](https://developer.apple.com/documentation/uikit/uitableviewdiffabledatasource), two of the most recent UIKit APIs to work with `UICollectonView`.
It also supports different size classes, but it does not support scenes for iPad or large iPhone.

### Architecture

The app showcases a `MVVM+C` architecture. The C stands for [Coordinator](https://khanlou.com/2015/01/the-coordinator/). It showcases a layered architecture to encapsulate data management using DDD concepts. It uses (Combine)[https://developer.apple.com/documentation/combine] for async work and bindings. Unit tests and UI tests where added to test every layer of the application.


### Data

The data of the characters is taking from [Marvel's API](https://developer.marvel.com)
