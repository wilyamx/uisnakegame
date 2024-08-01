# Skillful Snake

Snake game built using **UIKit**. Our different way to study iOS Swift Language.

## Featured List

1. Home
	- Leaderboard
	- Settings
	- About

2. Game
	- New Game / Continue
	- 2 Play mode (map based, casual)
	- Snake Collision (itself, obstacles)
	- Pause / Play / Restart
	- Timer Enabled Play
	- Swipe or Keyboard Gesture
	- Configurable

3. Game Levels
	- Custom Level Design via JSON file
	- On/Off Sound Effects (Eating, Collision, Background, Gameover)

4. Skills
	- Allow body collision (flexible body) - PENDING
	- Hard headed snake (can destroy obstacles) - PENDING


## GAME MECHANICS

- [Gameplay] Use can play either map-based (default) or casual from app settings.
- [Gameplay] User will force to play casual game if unable to load game configuration file.
- [Leaderboard] Active user will be highlighted in the leaderboard to motivate increase ranking.
- [Leaderboard] Separate leaderboard map-based and casual play mode.
- [Score] User will earn stage points only if completed the stage.
- [Score] As the snake length increases the food credit also vary. 
- [Snake] Snake will update it's length only if completed the stage.
- [Snake] As the snake grows the speed increases.
- [Sound] Sound effects can be on/off from the app settings.
- [Sound] Sound effects for character (Eating, Change Direction), popups (Game Over, Level Up), background 
- [Stage] A stage is cleared or completed if game is not over yet until time is up.

## Technology

PROJECT SPECIFICATIONS

- **IDE:** `XCode 15.4 for iOS 17.5`
- **Language:** `Swift 5`
- **Interface:** `Storyboard`

## Technical Implementations

- MVVM + Combine
- Property Wrappers
- Custom Logger
- User Defaults
- Target Schemes (Production and Development Environment)
- Package Dependencies
	- [Eureka](https://eurekacommunity.github.io/) - [iOS form builder](https://github.com/xmartlabs/eureka)
	- [SuperEasyLayout](https://github.com/doil6317/SuperEasyLayout) - apply UI constraints programmatically

## Screenshots

<p float="left">
		<img src="screenshots/01_snk_launch_screen.png" alt="ChatPeopleViewController" height="500">
		<img src="screenshots/02_snk_home_screen.png" alt="ChatMessagingViewController" height="500">
		<img src="screenshots/03_snk_settings.png" alt="ChatMessagingViewController" height="500">
		<img src="screenshots/04_snk_leaderboard.png" alt="ChatMessagingViewController" height="500">
		<img src="screenshots/05_snk_snake_game.png" alt="ChatMessagingViewController" height="500">
	<p float="left">