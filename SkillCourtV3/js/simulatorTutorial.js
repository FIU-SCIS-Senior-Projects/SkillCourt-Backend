var simulatorguide = introJs();

$(function SimulatorTutorialGuide(){
  // var startbtn   = $('#startdemotour');
  
  simulatorguide.setOptions({
    steps: [
    {
      element: '#bannerImg',
      intro: 'Welcome to SkillCourt Simulator Tutorial',
      position: 'bottom'
    },
    {
      element: '#SimSettings',
      intro: 'The phone represents the settings for the simulator and provides the feedback once the game has started',
      position: 'right'
    },
    {
      element: '#leTabs',
      intro: 'The DEFAULT option will show the pre-defined routines while CUSTOM the ones assigned by a coach',
      position: 'top'
    },
    {
      element: '#sStep4',
      intro: 'When checked, this option allows the player to remove a wall from the simulator',
      position: 'right'
    },
    {
      element: '#sStep5',
      intro: "List of pre-defined routines to simulate. Select your favorite or challenge yourself",
      position: 'left'
    },
    {
      element: '#difficultyRadioButton',
      intro: "Sets the difficulty for the routine. An increase in difficulty makes the correct spot to click more specific",
      position: 'right'
    },
    {
      element: '#sStep7',
      intro: "This option adds a time limit to each round narrowing the player's reaction time window",
      position: 'left'
    },
    {
      element: '#sStep8',
      intro: "Total time for the routine simulation",
      position: 'right'
    },
    {
      element: '#sStep9',
      intro: "Clicking PLAY! will start the simulator with routine and settings selected. Feedback is provided when simulation begins. Time to play!",
      position: 'top'
    }
    ]
  });
});


