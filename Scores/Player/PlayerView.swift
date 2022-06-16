//
//  PlayerView.swift
//  Scores
//
//  Created by Jindrich Stepanek on 15.06.2022.
//

import SwiftUI
import Kingfisher

struct PlayerView: View {
    
    @StateObject var viewModel: PlayerViewModel

    private var player: Player { viewModel.player }
    private var team: Team? { viewModel.team }

    var image: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .foregroundColor(.black.opacity(0.7))
            .frame(width: 100, height: 100, alignment: .center)
            .scaledToFit()
    }

    var nameText: some View {
        Text(player.name ?? "")
            .foregroundColor(.black.opacity(0.8))
            .font(.system(size: 30).bold())
    }

    var nationalityText: some View {
        Text("\(flagEmoji)  \(player.nationality ?? "")")
            .foregroundColor(.black.opacity(0.7))
            .font(.system(size: 20))
    }

    var positionText: some View {
        Text(player.position ?? "")
            .foregroundColor(.black.opacity(0.7))
            .font(.system(size: 20))
    }

    var teamView: some View {
        HStack {
            SVGImage(svgUrl: team?.crestURL)
                .resizable()
                .frame(width: 60, height: 60, alignment: .center)
                .scaledToFit()
            Text(team?.name ?? "")
                .padding(.leading, 8)
                .foregroundColor(.black.opacity(0.7))
                .font(.system(size: 20).bold())
        }
    }
    
    var body: some View {
        VStack {
            Spacer().frame(height: 20)
            image
            nameText.padding(.top, 16)
            positionText.padding(.top, 4)
            nationalityText.padding(.top, 4)
            teamView.padding(.top, 10)
            Spacer()
        }.navigationTitle(player.name ?? "")
            .onAppear(perform: fetchTeam)
    }
    
    var flagEmoji: String {
        FlagMap.map[player.nationality ?? ""]?.emoji ?? "🌎"
    }

    private func fetchTeam() {
        guard viewModel.team == nil else { return }
        viewModel.fetchTeam()
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        let team = Team(
            id: 1,
            name: "Manchester United",
            shortName: "Man Utd",
            crest: nil,
            squad: nil
        )
        let player = Player(
            id: 1,
            name: "Cristiano Ronaldo",
            position: "Left Winger",
            dateOfBirth: "22.10.1988",
            nationality: "Portugal",
            shirtNumber: 7,
            currentTeam: nil
        )
        let viewModel = PlayerViewModel(player: player, team: team)
        
        return NavigationView {
            PlayerView(viewModel: viewModel)
        }
    }
}
