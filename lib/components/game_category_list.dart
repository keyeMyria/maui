import 'dart:math';
import 'package:maui/db/entity/concept.dart';
import 'package:maui/games/single_game.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'expansionTile.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/games/head_to_head_game.dart';
import 'package:maui/loca.dart';
import 'package:maui/repos/concept_repo.dart';
import 'package:maui/screens/game_category_list_screen.dart';

class GameCategoryList extends StatefulWidget {
  GameCategoryList(
      {Key key,
      @required this.gameCategories,
      @required this.game,
      @required this.gameMode,
      @required this.concepts,
      @required this.gameDisplay,
      this.otherUser})
      : super(key: key);
  State<StatefulWidget> createState() => new _GameCategoryList();
  final List<Tuple3<int, int, String>> gameCategories;
  final String game;
  GameMode gameMode;
  GameDisplay gameDisplay;
  User otherUser;
  Map<int, Concept> concepts;
}

class GameCategoryData {
  int id;
  int conceptId;
  String name;
  GameCategoryData(this.id, this.conceptId, this.name);
  @override
  String toString() {
    return '{id: $id, conceptId: $conceptId, name: $name}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameCategoryData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          conceptId == other.conceptId &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ conceptId.hashCode ^ name.hashCode;
}

class _GameCategoryList extends State<GameCategoryList> {
  static final List<Color> colorsCodes = [
    Color(0XFF48AECC),
    Color(0XFFE66796),
    Color(0XFFFF7676),
    Color(0XFFEDC23B),
    Color(0XFFAD85F9),
    Color(0XFF77DB65),
    Color(0XFF66488C),
    Color(0XFFDD6154),
    Color(0XFFFFCE73),
    Color(0XFFD64C60),
    Color(0XFFDD4785),
    Color(0XFF52C5CE),
    Color(0XFFF97658),
    Color(0XFFA46DBA),
    Color(0XFFA292FF),
    Color(0XFFFF8481),
    Color(0XFF35C9C1),
    Color(0XFFEDC23B),
    Color(0XFF42AD56),
    Color(0XFFF47C5D),
    Color(0XFF77DB65),
    Color(0XFF57DBFF),
    Color(0XFFEB706F),
    Color(0XFF48AECC),
    Color(0XFFFFC729),
    Color(0XFF30C9E2),
    Color(0XFFA1EF6F),
  ];
  static final List<Color> tileColors = [];
  int count = 0;
  bool isLoading = false;
  List<GameCategoryData> gameCategoryData;
  Map<int, List<GameCategoryData>> conceptIdMap;

  @override
  void initState() {
    super.initState();
    gameCategoryData = widget.gameCategories.map((tuple3) {
      return new GameCategoryData(tuple3.item1, tuple3.item2, tuple3.item3);
    }).toList();
    conceptIdMap = {};
    gameCategoryData.forEach((data) {
      conceptIdMap
          .putIfAbsent(data.conceptId, () => new List<GameCategoryData>())
          .add(data);
    });
    conceptIdMap.forEach((key, value) {
      print("$key - ${value.length}");
      print('value is $value');
    });
    int categoriesLength = widget.gameCategories.length;
    for (int i = 0; i < categoriesLength + 1; i++) {
      if (count == 26) count = 0;
      tileColors.add(colorsCodes[count]);
      count++;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return new Center(
          child: new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      ));
    }
    Orientation orientation = MediaQuery.of(context).orientation;
    Size media = MediaQuery.of(context).size;
    int j = 0;
    return new CustomScrollView(
      primary: true,
      shrinkWrap: false,
      slivers: <Widget>[
        new SliverAppBar(
            backgroundColor:
                SingleGame.gameColors[widget.game][0] ?? Colors.amber,
            pinned: true,
            expandedHeight: orientation == Orientation.portrait
                ? media.height * .25
                : media.height * .5,
            title: new Text(Loca.of(context).intl(widget.game)),
            flexibleSpace: new FlexibleSpaceBar(
              background: new Stack(children: <Widget>[
                new Container(
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: new AssetImage(
                          "assets/background_image/reflex_big.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Center(
                      child: new Hero(
                        tag: 'assets/hoodie/${widget.game}.png',
                        child: new Image.asset(
                          'assets/hoodie/${widget.game}.png',
                          scale: .4,
                        ),
                      ),
                    ))
              ]),
              // centerTitle: true,
            )),
        new SliverList(
            delegate: new SliverChildListDelegate(_buildCategoriesButtons())),
        new SliverToBoxAdapter(
          child: new Container(height: 2.0, color: Colors.yellow),
        ),
      ],
    );
  }

  List<Widget> _buildCategoriesButtons() {
    List<Widget> buttons = [];
    int colorIndex = 0;
      conceptIdMap.forEach((conceptId, list) {
      String mainCategoryName = widget.concepts[conceptId].name;
      if (list.length == 1) {
        buttons.add(_buildButton(
            mainCategoryName, list.first.id, tileColors[colorIndex++]));
      } else {
        buttons.add(Container(
          color: tileColors[colorIndex++],
          child: new ExpansionTiles(
            title: Container(
                height: 154.0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 64.0, 0.0, 0.0),
                  child: new Text(mainCategoryName,
                      style: TextStyle(
                          letterSpacing: 2.0,
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold)),
                )),
            children: list.map((gameCategoryData) {
              return _buildButton(gameCategoryData.name, gameCategoryData.id,
                  tileColors[colorIndex - 1]);
            }).toList(),
          ),
        ));
      }
    });
    return buttons;
  }

  Widget _buildButton(
      String mainCategoryName, int gameCategoryId, Color color) {
    return new Container(
      height: 154.0,
      color: color,
      child: ListTile(
        title: new Container(
            child: Text(mainCategoryName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold))),
        onTap: () => goToGame(context, widget.game, gameCategoryId,
            widget.gameDisplay, widget.gameMode,
            otherUser: widget.otherUser),
      ),
    );
  }

  void goToGame(BuildContext context, String gameName, int gameCategoryId,
      GameDisplay gameDisplay, GameMode gameMode,
      {User otherUser}) {
    Random random = new Random();
    var gameConfig = new GameConfig(
        gameCategoryId: gameCategoryId,
        questionUnitMode: UnitMode.values[random.nextInt(3)],
        answerUnitMode: UnitMode.values[random.nextInt(3)],
        level: random.nextInt(10) + 1);
    print('goToGame: $gameName $gameCategoryId, $gameDisplay, $gameMode');
    switch (gameDisplay) {
      case GameDisplay.single:
        gameMode == GameMode.iterations
            ? Navigator.of(context).push(
                MaterialPageRoute<Null>(builder: (BuildContext context) {
                  gameConfig.gameDisplay = GameDisplay.single;
                  gameConfig.amICurrentPlayer = true;
                  gameConfig.myScore = 0;
                  gameConfig.myUser =
                      AppStateContainer.of(context).state.loggedInUser;
                  gameConfig.otherScore = 0;
                  gameConfig.orientation = MediaQuery.of(context).orientation;
                  return new SingleGame(
                    gameName,
                    gameMode: GameMode.iterations,
                    gameConfig: gameConfig,
                  );
                }),
              )
            : Navigator.of(context).push(
                MaterialPageRoute<Null>(builder: (BuildContext context) {
                  gameConfig.gameDisplay = GameDisplay.single;
                  gameConfig.orientation = MediaQuery.of(context).orientation;
                  gameConfig.myUser =
                      AppStateContainer.of(context).state.loggedInUser;
                  return new SingleGame(
                    gameName,
                    gameMode: GameMode.timed,
                    gameConfig: gameConfig,
                  );
                }),
              );
        break;
      case GameDisplay.localTurnByTurn:
        Navigator.of(context).push(
          MaterialPageRoute<Null>(builder: (BuildContext context) {
            gameConfig.gameDisplay = GameDisplay.localTurnByTurn;
            gameConfig.amICurrentPlayer = true;
            gameConfig.myUser =
                AppStateContainer.of(context).state.loggedInUser;
            gameConfig.otherUser = otherUser;
            gameConfig.myScore = 0;
            gameConfig.otherScore = 0;
            gameConfig.orientation = MediaQuery.of(context).orientation;
            return new SingleGame(
              gameName,
              gameMode: GameMode.iterations,
              gameConfig: gameConfig,
            );
          }),
        );
        break;
      case GameDisplay.networkTurnByTurn:
        Navigator.of(context).push(
          MaterialPageRoute<Null>(builder: (BuildContext context) {
            gameConfig.gameDisplay = GameDisplay.networkTurnByTurn;
            gameConfig.amICurrentPlayer = true;
            gameConfig.myUser =
                AppStateContainer.of(context).state.loggedInUser;
            gameConfig.otherUser = otherUser;
            gameConfig.myScore = 0;
            gameConfig.otherScore = 0;
            gameConfig.orientation = MediaQuery.of(context).orientation;
            return new SingleGame(
              gameName,
              gameMode: GameMode.iterations,
              gameConfig: gameConfig,
            );
          }),
        );
        break;
      case GameDisplay.myHeadToHead:
        gameConfig.orientation = Orientation.landscape;
        gameConfig.myUser = AppStateContainer.of(context).state.loggedInUser;
        gameConfig.otherUser = otherUser;
        gameMode == GameMode.iterations
            ? Navigator.of(context).push(MaterialPageRoute<Null>(
                  builder: (BuildContext context) => new HeadToHeadGame(
                        gameName,
                        gameMode: GameMode.iterations,
                        gameConfig: gameConfig,
                      ),
                ))
            : Navigator.of(context).push(MaterialPageRoute<Null>(
                  builder: (BuildContext context) => new HeadToHeadGame(
                        gameName,
                        gameMode: GameMode.timed,
                        gameConfig: gameConfig,
                      ),
                ));
    }
  }
}
