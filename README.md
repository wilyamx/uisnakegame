# Skillful Snake

Snake game built using **UIKit**. Our different way to study and explore iOS Swift Language.

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
	- Allow body collision (flexible body)
	- Hard headed snake (can destroy obstacles) - PENDING


## GAME MECHANICS

- [Gameplay] User can play either map-based (default) or casual from app settings.
- [Gameplay] User will force to play casual game if unable to load game configuration file.
- [Gameplay] Save the user last game progress and continue to play.
- [Gameplay] Support both orientation in the game environment only.
- [Gameplay] Has the option to reset data.
- [Gameplay] User can create his own profile to track the game progress.
- [Leaderboard] Active user will be highlighted in the leaderboard to motivate increase ranking.
- [Leaderboard] Separate leaderboard map-based and casual play mode.
- [Leaderboard] User ranking will update every complete of the stage.
- [Score] User will earn stage points only if completed the stage.
- [Score] As the snake length increases the food credit also vary. 
- [Snake] Snake will update it's length only if completed the stage.
- [Snake] As the snake grows the speed increases.
- [Sound] Sound effects can be on/off from the app settings.
- [Sound] Sound effects for character (Eating, Change Direction), popups (Game Over, Level Up), background 
- [Stage] A stage is cleared or completed if game is not over yet until time is up.
- [Stage] Configurable either time-based or eat all spawn food item to clear the stage.

## TILE IMAGES

<p float="left">
	<img src="images/snake.png" alt="light.panel.fill" height="50">
</p>

<p float="left">
	<img src="images/light.panel.fill.png" alt="light.panel.fill" height="100">
	<img src="images/rotate.3d.fill.png" alt="rotate.3d.fill" height="100">
</p>

<p float="left">
	<img src="images/water.waves.png" alt="water.waves" height="100">
	<img src="images/pill.fill.png" alt="pill.fill" height="100">
	<img src="images/staroflife.circle.fill.png" alt="staroflife.circle.fill" height="100">
</p>

## TECHNOLOGY

PROJECT SPECIFICATIONS

- **IDE:** `XCode 15.4 for iOS 17.5`
- **Language:** `Swift 5`
- **Interface:** `Storyboard`

## Technical Implementations

- 2 Dimensional Array Grid Layout
- MVVM + Combine
- Coordinator Design Pattern for Navigations
- Property Wrappers
- Custom Logger
- User Defaults
- Target Schemes (Production and Development Environment)
- Package Dependencies
	- [Eureka](https://eurekacommunity.github.io/) - [iOS form builder](https://github.com/xmartlabs/eureka)
	- [SuperEasyLayout](https://github.com/doil6317/SuperEasyLayout) - apply UI constraints programmatically

## SCREENSHOTS

<p float="left">
	<img src="screenshots/01_snk_launch_screen.png" alt="01_snk_launch_screen" height="500">
	<img src="screenshots/02_snk_new_game_profile.png" alt="02_snk_new_game_profile" height="500">
	<img src="screenshots/03_snk_home_screen.png" alt="03_snk_home_screen" height="500">
	<img src="screenshots/04_snk_settings_screen.png" alt="04_snk_settings_screen" height="500">
	<img src="screenshots/08_snk_leaderboard.png" alt="08_snk_leaderboard" height="500">
	<img src="screenshots/09_snk_about.png" alt="09_snk_about" height="500">
</p>

<p float="left">
	<img src="screenshots/05_snk_map_game_1_objective.png" alt="05_snk_map_game_1_objective" height="500">
	<img src="screenshots/05_snk_map_game_2_welcome_stage.png" alt="05_snk_map_game_2_welcome_stage" height="500">
	<img src="screenshots/05_snk_map_game_3_game.png" alt="05_snk_map_game_3_game" height="500">
	<img src="screenshots/05_snk_map_game_4_stage_complete.png" alt="05_snk_map_game_4_stage_complete" height="500">
	<img src="screenshots/05_snk_map_game_5_game_over.png" alt="05_snk_map_game_5_game_over" height="500">
	<img src="screenshots/05_snk_map_game_6_stage_all_completed.png" alt="05_snk_map_game_6_stage_all_completed" height="500">
</p>

<p float="left">
	<img src="screenshots/06_snk_map_game_stage_1.png" alt="06_snk_map_game_stage_1" height="500">
	<img src="screenshots/06_snk_map_game_stage_2.png" alt="06_snk_map_game_stage_2" height="500">
	<img src="screenshots/06_snk_map_game_stage_4.png" alt="06_snk_map_game_stage_4" height="500">
	<img src="screenshots/06_snk_map_game_stage_5.png" alt="06_snk_map_game_stage_5" height="500">
</p>

<p float="left">
	<img src="screenshots/07_snk_casual_game_1_objective.png" alt="07_snk_casual_game_1_objective" height="500">
	<img src="screenshots/07_snk_casual_game_2_welcome_stage.png" alt="07_snk_casual_game_2_welcome_stage" height="500">
	<img src="screenshots/07_snk_casual_game_3_game.png" alt="07_snk_casual_game_3_game" height="500">
	<img src="screenshots/07_snk_casual_game_4_stage_complete.png" alt="07_snk_casual_game_4_stage_complete" height="500">
</p>

## FUTURE IMPROVEMENTS

1. Orientation support for horizontal and vertical oriented obstacle design
1. Snake image skinning
1. Uploadable game config to share new personalized obstacle designs
1. Map-based obstacle maker to matrix data
1. 2 players battle for hi-score using shared obstacle design
1. Haptic feedback for wrong direction
