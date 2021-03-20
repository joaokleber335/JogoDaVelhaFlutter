import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jogodavelha/models/jogador_model.dart';

class JogoDaVelhaPage extends StatefulWidget {
  @override
  _JogoDaVelhaPageSate createState() => _JogoDaVelhaPageSate();
}

class _JogoDaVelhaPageSate extends State<JogoDaVelhaPage> {
  Player _playerOfTurn;
  Player _playerX = Player(name: 'X');
  Player _playerO = Player(name: 'O');

  List<List<Player>> _board = [
    [null, null, null],
    [null, null, null],
    [null, null, null],
  ];

  bool gameStarted = false;

  @override
  void initState() {
    _playerOfTurn = _playerX;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Jogo da velha'),
          elevation: 0,
          backgroundColor: Colors.purple,
        ),
        // body: Container(color: Colors.blueGrey, child: _createBoard()),
        body: createContent());
  }

  Widget createContent() {
    return Column(
      children: [
        Expanded(
            flex: 2,
            child: Container(color: Colors.white, child: _createBoard())),
        Expanded(
            child:
                Container(color: Colors.white, child: _createContentBottom())),
      ],
    );
  }

  void reset() {
    _playerOfTurn = _playerX;
    _board = [
      [null, null, null],
      [null, null, null],
      [null, null, null],
    ];
  }

  Widget _createBoard() {
    final List<int> listaFixa = Iterable<int>.generate(_board.length).toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: listaFixa.map((j) => _createRow(_board[j], j)).toList(),
    );
  }

  Widget _createRow(List<Player> linha, int j) {
    final List<int> listaFixa = Iterable<int>.generate(linha.length).toList();
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            listaFixa.map((i) => _createPosition(linha[i], j, i)).toList(),
      ),
    );
  }

  Widget _createPosition(Player player, int j, int i) {
    return Container(
      child: GestureDetector(
        onTap: () {
          _move(j, i);
          gameStarted = true;
        },
        child: Container(
          height: 100,
          width: 100,
          color: Colors.grey[350],
          child: Center(
            child: _createImagePosition(player),
          ),
        ),
      ),
    );
  }

  Image _createImagePosition(Player player) {
    if (player == null) {
      return null;
    }
    if (player.name == 'X') {
      return Image.asset('assets/x.png');
    } else {
      return Image.asset('assets/o.png');
    }
  }

  Widget _createContentBottom() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Jogador da vez: ${_playerOfTurn.name}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),

              // TextStyle(
              // child:
              //     )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [gameStarted ? createButtonRestart() : Text('')],
        ),
      ],
    );
  }

  ElevatedButton createButtonRestart() {
    return ElevatedButton(
        child: Text('Restart'),
        onPressed: () {
          setState(() {
            reset();
          });
        },
        style: styleButtonRestart());
  }

  ButtonStyle styleButtonRestart() {
    return ElevatedButton.styleFrom(
        primary: Colors.purple,
        padding: EdgeInsets.symmetric(
          horizontal: 70,
          vertical: 15,
        ),
        textStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ));
  }

  void _move(int j, int i) {
    if (_board[j][i] == null) {
      setState(() => _board[j][i] = _playerOfTurn);
      _checkWinner();
      _swapPlayer();
    } else {
      _showMessage('Está posição já está ocupada, tente utilizar outra!');
    }
  }

  void _swapPlayer() {
    setState(() {
      _playerOfTurn = _playerOfTurn.name == 'X' ? _playerO : _playerX;
    });
  }

  void _showMessage(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          // Scaffold.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // Scaffold.of(context).showSnackBar(snackBar);
  }

  void _checkWinner() {
    _checkHorizontal();
    _checkVertical();
    _checkDiagonal();
  }

  void _checkHorizontal() {
    for (var i = 0; i < 3; i++) {
      if (_board[i][0] != null &&
          _board[i][0] == _board[i][1] &&
          _board[i][0] == _board[i][2]) {
        _showMessage('O jogador ${_board[i][0].name} ganhou!');
      }
    }
  }

  void _checkVertical() {
    for (var i = 0; i < 3; i++) {
      if (_board[0][i] != null &&
          _board[0][i] == _board[1][i] &&
          _board[0][i] == _board[2][i]) {
        _showMessage('O jogador ${_board[0][i].name} ganhou!');
      }
    }
  }

  void _checkDiagonal() {
    if (_board[0][0] != null &&
        _board[0][0] == _board[1][1] &&
        _board[0][0] == _board[2][2]) {
      _showMessage('O jogador ${_board[0][0].name} ganhou!');
    } else if (_board[0][2] != null &&
        _board[0][2] == _board[1][1] &&
        _board[0][2] == _board[2][0]) {
      _showMessage('O jogador ${_board[0][2].name} ganhou!');
    }
  }
}
