//: Playground - noun: a place where people can play

import UIKit

/*//1o exemplo - Escopo do Playground

/* O escopo do playground segura as variáveis na memória. Quando o playground for desalocado,
 as variáveis saem da memória

 RC Team: 1
 RC Player: 1

*/

class Team {
    var name: String
    private(set) var squad: [Player] = []

    init(name: String) {
        self.name = name
        print("Team \(name) initialized")
    }

    deinit {
        print("Team \(name) deallocated")
    }
}

class Player {
    var name: String

    init(name: String) {
        self.name = name
        print("Player \(name) initialized")
    }

    deinit {
        print("Player \(name) deallocated")
    }
}

let team = Team(name: "Real Madrid")
let cr7 = Player(name: "Cristiano Ronaldo")
*/

/*//2o exemplo - Variáveis perdem a referência do escopo quando saem dele

/* As variáveis permanecem alocadas apenas quando estão dentro do escopo do 'do'

 Antes do 'do'
 RC Team: 1
 RC Player: 1

 Após o 'do'
 RC Team: 0
 RC Player: 0

*/

class Team {
    var name: String
    private(set) var squad: [Player] = []

    init(name: String) {
        self.name = name
        print("Team \(name) initialized")
    }

    deinit {
        print("Team \(name) deallocated")
    }
}

class Player {
    var name: String

    init(name: String) {
        self.name = name
        print("Player \(name) initialized")
    }

    deinit {
        print("Player \(name) deallocated")
    }
}

do {
    let team = Team(name: "Real Madrid")
    let cr7 = Player(name: "Cristiano Ronaldo")
}*/


/*//3o exemplo - Referência cíclica faz as variáveis não serem liberadas

/* Team tem uma referência forte para Player, e Player tem uma referência forte para Team. Essa referência cíclica faz
 o contador de ambos aumentar em 1

 Antes do 'do'
 RC Team: 2 (1 do contexto do 'do', e 1 da referência do 'Player')
 RC Player: 2 (1 do contexto do 'do', e 1 da referência do 'Team')

 Após o 'do'
 RC Team: 1 (1 da referência do 'Player')
 RC Player: 1 (1 da referência do 'Team')
*/

class Team {
    var name: String
    private(set) var squad: [Player] = []

    init(name: String) {
        self.name = name
        print("Team \(name) initialized")
    }

    deinit {
        print("Team \(name) deallocated")
    }

    func addPlayer(player: Player) {
        squad.append(player)
        player.club = self
    }
}

class Player {
    var name: String
    var club: Team?

    init(name: String) {
        self.name = name
        print("Player \(name) initialized")
    }

    deinit {
        print("Player \(name) deallocated")
    }
}

do {
    let team = Team(name: "Real Madrid")
    let cr7 = Player(name: "Cristiano Ronaldo")

    team.addPlayer(player: cr7)
}
*/

/*//4o exemplo - Weak (Utilizar referências fracas é uma maneira de corrigir problemas de referência cíclica)

/*

 Uma maneira de resolver esse problema é adicionar weak na variável club do Player. Como um Team obrigatoriamente
 precisa de players, e não necessariamente um Player precisa estar associado a um Team, a melhor estratégia é colocar
 a referência fraca na variável que é opcional.

 Ao adicionar o weak, o contador de referências do Team não aumenta, pois ele está sendo referenciado por uma
 referência fraca, então ele consegue ser liberado da memória após o 'do', pois seu contador chega a 0.

 Antes do 'do'
 RC Team: 1 (contexto do 'do')
 RC Player: 2 (1 do contexto do 'do', e 1 da referência do 'Team')

 Após o 'do'
 RC Team: 0 (saiu do 'do', o RC chega a 0, e então é liberado da memória)
 RC Player: 0 (o RC diminui 1 quando sai do contexto do 'do', e mais 1 quando não é mais referenciado pelo Team, quando
 o mesmo é desalocado. Ao chegar a 0, também é liberado da memória.)

*/

class Team {
    var name: String
    private(set) var squad: [Player] = []

    init(name: String) {
        self.name = name
        print("Team \(name) initialized")
    }

    deinit {
        print("Team \(name) deallocated")
    }

    func addPlayer(player: Player) {
        squad.append(player)
        player.club = self
    }
}

class Player {
    var name: String
    weak var club: Team?

    init(name: String) {
        self.name = name
        print("Player \(name) initialized")
    }

    deinit {
        print("Player \(name) deallocated")
    }
}

do {
    let team = Team(name: "Real Madrid")
    let cr7 = Player(name: "Cristiano Ronaldo")

    team.addPlayer(player: cr7)
}*/

/*//5o exemplo - Outra referência cíclica por dupla referência forte

/*

Ao adicionarmos essa referência forte, caímos novamente no problema de referência cíclica

 Antes do 'do'
 RC Team: 2 (contexto do 'do' + referência do Sponsorship)
 RC Player: 2 (1 do contexto do 'do', e 1 da referência do 'Team')
 RC Sponsorship: 2 (contexto do 'do' + referência do Team)

 Após o 'do'
 RC Team: 1 (saiu do 'do', mas ainda guarda a referência forte do Sponsorship)
 RC Player: 1 (saiu do 'do', mas ainda guarda a referência forte do Team)
 RC Sponsorship: 1 (saiu do 'do', mas ainda guarda a referência forte do Team)

*/

class Team {
    var name: String
    private(set) var squad: [Player] = []
    var sponsorship: [Sponsorship] = []

    init(name: String) {
        self.name = name
        print("Team \(name) initialized")
    }

    deinit {
        print("Team \(name) deallocated")
    }

    func addPlayer(player: Player) {
        squad.append(player)
        player.club = self
    }
}

class Player {
    var name: String
    weak var club: Team?

    init(name: String) {
        self.name = name
        print("Player \(name) initialized")
    }

    deinit {
        print("Player \(name) deallocated")
    }
}

class Sponsorship {
    var name: String
    let value: String
    let duration: String
    var club: Team

    init(name: String, value: String, duration: String, club: Team) {
        self.name = name
        self.value = value
        self.duration = duration
        self.club = club

        club.sponsorship.append(self)

        print("Sponsorship \(name) initialized")
    }

    deinit {
        print("Sponsorship \(name) deallocated")
    }
}

do {
    let team = Team(name: "Real Madrid")
    let cr7 = Player(name: "Cristiano Ronaldo")
    let adidas = Sponsorship(name: "Adidas", value: "200kk", duration: "2 anos", club: team)

    team.addPlayer(player: cr7)
}*/

/*//6o exemplo - Unowned é a solução para os casos em que a variável, que queremos colocar
                referência fraca, não é opcional

 /*

 Não podemos adicionar o weak, porque o weak é para variáveis opcionais. Para constantes ou variáveis não opcionais,
 precisamos utilizar unowned. Adicionando unowned, conseguimos criar uma referência fraca entre o Sponsorship e
 o Team. Assim, resolvemos nosso problema.

 Antes do 'do'
 RC Team: 1 (contexto do 'do')
 RC Player: 2 (1 do contexto do 'do', e 1 da referência do 'Team')
 RC Sponsorship: 2 (contexto do 'do' + referência do Team)

 Após o 'do'
 RC Team: 0 (saiu do 'do', então é liberado da memória)
 RC Player: 0 (saiu do 'do', e perdeu a referência forte feita pelo Team, quando o mesmo foi desalocado da memória)
 RC Sponsorship: 0 (saiu do 'do', e perdeu a referência forte feita pelo Team, quando o mesmo foi desalocado da memória)

 */

class Team {
    var name: String
    private(set) var squad: [Player] = []
    var sponsorship: [Sponsorship] = []

    init(name: String) {
        self.name = name
        print("Team \(name) initialized")
    }

    deinit {
        print("Team \(name) deallocated")
    }

    func addPlayer(player: Player) {
        squad.append(player)
        player.club = self
    }
}

class Player {
    var name: String
    weak var club: Team?

    init(name: String) {
        self.name = name
        print("Player \(name) initialized")
    }

    deinit {
        print("Player \(name) deallocated")
    }
}

class Sponsorship {
    var name: String
    let value: String
    let duration: String
    unowned var club: Team

    init(name: String, value: String, duration: String, club: Team) {
        self.name = name
        self.value = value
        self.duration = duration
        self.club = club

        club.sponsorship.append(self)

        print("Sponsorship \(name) initialized")
    }

    deinit {
        print("Sponsorship \(name) deallocated")
    }
}

do {
    let team = Team(name: "Real Madrid")
    let cr7 = Player(name: "Cristiano Ronaldo")
    let adidas = Sponsorship(name: "Adidas", value: "200kk", duration: "2 anos", club: team)

    team.addPlayer(player: cr7)
}*/

/*//7o exemplo - Listas de captura

 /*

 Qual valor será printado quando closure for executada? Será o valor 60 e 90. Ao passar 'x' por parâmetro, criamos
 uma cópia dele e passamos por parâmetro. Então não importa se posteriormente o valor de 'x' será atualizado, pois
 o valor utilizado na closure será o valor passado por parâmetro.

 */

var x = 60
var y = 70

var closure = { [x] in
    print("x = \(x) e y = \(y)")
}

x = 80
y = 90

closure()
*/

/*//8o exemplo - Closures que referenciam a mesma classe podem criar referência cíclica

/*

 Se dentro de uma closure chamada por uma classe, fizermos uso do self, a classe fará uma referência para ela mesma. Se deixarmos essa referência forte, teremos uma referência cíclica da classe para ela mesma.

 Antes do 'do'
 RC Team: 2 (contexto do 'do' + referência da classe para ela mesmo ao fazer o print do contrato)
 RC Player: 2 (1 do contexto do 'do', e 1 da referência do 'Team')
 RC Sponsorship: 2 (contexto do 'do' + referência do Team)

 Após o 'do'
 RC Team: 1 (saiu do 'do')
 RC Player: 1 (saiu do 'do')
 RC Sponsorship: 1 (saiu do 'do')
 */


class Team {
    var name: String
    private(set) var squad: [Player] = []
    var sponsorship: [Sponsorship] = []

    init(name: String) {
        self.name = name
        print("Team \(name) initialized")
    }

    deinit {
        print("Team \(name) deallocated")
    }

    func addPlayer(player: Player) {
        squad.append(player)
        player.club = self
    }
}

class Player {
    var name: String
    weak var club: Team?

    init(name: String) {
        self.name = name
        print("Player \(name) initialized")
    }

    deinit {
        print("Player \(name) deallocated")
    }
}

class Sponsorship {
    var name: String
    let value: String
    let duration: String
    unowned var club: Team

    init(name: String, value: String, duration: String, club: Team) {
        self.name = name
        self.value = value
        self.duration = duration
        self.club = club

        club.sponsorship.append(self)

        print("Sponsorship \(name) initialized")
    }

    lazy var fullContract: () -> String = { [unowned self] in
        return self.name + " \(self.value)" + " \(self.duration)"
    }

    deinit {
        print("Sponsorship \(name) deallocated")
    }
}

do {
    let team = Team(name: "Real Madrid")
    let cr7 = Player(name: "Cristiano Ronaldo")
    let adidas = Sponsorship(name: "Adidas", value: "200kk", duration: "2 anos", club: team)

    team.addPlayer(player: cr7)

    print(adidas.fullContract())
}*/

/*//9o exemplo - Em clojures com [unowned self], teremos um crash se self for nulo.

 /*

 Como vimos antes, unowned garante que aquela variável não é opcional. Então, se tentarmos utilizar essa variável e
 ela contiver um valor nulo, teremos um crash. O que acontece nesse exemplo é que a função batata está sendo chamada
 fora do escopo do 'do', quando Sponsorship já foi desalocada. Ao tentar chamar 'self', teremos um crash, pois self
 é nulo.

 */


class Team {
    var name: String
    private(set) var squad: [Player] = []
    var sponsorship: [Sponsorship] = []

    init(name: String) {
        self.name = name
        print("Team \(name) initialized")
    }

    deinit {
        print("Team \(name) deallocated")
    }

    func addPlayer(player: Player) {
        squad.append(player)
        player.club = self
    }
}

class Player {
    var name: String
    weak var club: Team?

    init(name: String) {
        self.name = name
        print("Player \(name) initialized")
    }

    deinit {
        print("Player \(name) deallocated")
    }
}

class Sponsorship {
    var name: String
    let value: String
    let duration: String
    unowned var club: Team

    init(name: String, value: String, duration: String, club: Team) {
        self.name = name
        self.value = value
        self.duration = duration
        self.club = club

        club.sponsorship.append(self)

        print("Sponsorship \(name) initialized")
    }

    lazy var fullContract: () -> String = { [unowned self] in
        return self.name + " \(self.value)" + " \(self.duration)"
    }

    deinit {
        print("Sponsorship \(name) deallocated")
    }
}

var batata: () -> String

do {
    let team = Team(name: "Real Madrid")
    let cr7 = Player(name: "Cristiano Ronaldo")
    let adidas = Sponsorship(name: "Adidas", value: "200kk", duration: "2 anos", club: team)

    team.addPlayer(player: cr7)

    batata = adidas.fullContract

    print(adidas.fullContract())
}

batata()
*/

/*//10o exemplo - Em clojures que precisamos utilizar 'self', colocamos [weak self] para quando 'self' é opcional.

 /*

 Vimos que existe um caso em que chamamos a função 'batata', e self está nulo. Então vemos que self na verdade pode não
 existir, e deveria ser um opcional. Precisamos então trocar unowned para weak, e não teremos mais esse problema.

 Antes do 'do'
 RC Team: 1 (contexto do 'do')
 RC Player: 2 (1 do contexto do 'do', e 1 da referência do 'Team')
 RC Sponsorship: 2 (contexto do 'do' + referência do Team)

 Após o 'do'
 RC Team: 0 (saiu do 'do', então é liberado da memória)
 RC Player: 0 (saiu do 'do', e perdeu a referência forte feita pelo Team, quando o mesmo foi desalocado da memória)
 RC Sponsorship: 0 (saiu do 'do', e perdeu a referência forte feita pelo Team, quando o mesmo foi desalocado da memória)

 */
*/
class Team {
    var name: String
    private(set) var squad: [Player] = []
    var sponsorship: [Sponsorship] = []

    init(name: String) {
        self.name = name
        print("Team \(name) initialized")
    }

    deinit {
        print("Team \(name) deallocated")
    }

    func addPlayer(player: Player) {
        squad.append(player)
        player.club = self
    }
}

class Player {
    var name: String
    weak var club: Team?

    init(name: String) {
        self.name = name
        print("Player \(name) initialized")
    }

    deinit {
        print("Player \(name) deallocated")
    }
}

class Sponsorship {
    var name: String
    let value: String
    let duration: String
    unowned var club: Team

    init(name: String, value: String, duration: String, club: Team) {
        self.name = name
        self.value = value
        self.duration = duration
        self.club = club

        club.sponsorship.append(self)

        print("Sponsorship \(name) initialized")
    }

    lazy var fullContract: () -> String = { [weak self] in
        guard let strongSelf = self else {
            return "Sorry"
        }
        return strongSelf.name + " \(strongSelf.value)" + " \(strongSelf.duration)"
    }

    deinit {
        print("Sponsorship \(name) deallocated")
    }
}

var batata: () -> String

do {
    let team = Team(name: "Real Madrid")
    let cr7 = Player(name: "Cristiano Ronaldo")
    let adidas = Sponsorship(name: "Adidas", value: "200kk", duration: "2 anos", club: team)

    team.addPlayer(player: cr7)

    batata = adidas.fullContract

    print(adidas.fullContract())
}

batata()
//*/
