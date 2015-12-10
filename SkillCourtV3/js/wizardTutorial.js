var wizardguide = introJs();

  $(setInterval(function wizardTutorialGuide(){
    // var startbtn   = $('#startdemotour');
        try {
          if($(WizardOptions).is(":visible") ) {

            wizardguide.setOptions({
              steps: [
              {
                element: '#bannerImg',
                intro: 'Welcome to SkillCourt Wizard Tutorial',
                position: 'bottom'
              },
              {
                element: '#routineSwitch',
                intro: 'Switching to DEFAULT option allows you to create a customized routine based on the pre-defined system routines',
                position: 'left'
              },
              {
                element: '#stepType',
                intro: 'This option allows you to base the routine between wall or ground targets',
                position: 'right'
              },
              {
                element: '#simulator',
                intro: 'Select a group of pads to make up a target. Your pads must be adjacent and on the same wall. When the correct pads are selected, press the FINISH STEP button',
                position: 'right'
              },
              {
                element: '#wStep5',
                intro: "Routines are made of rounds, which are made of steps. This allows for deep and endless customizations",
                position: 'top'
              },
              {
                element: '#wStep6',
                intro: "(+) Adds an extra step to a round",
                position: 'right'
              },
              {
                element: '#wStep7',
                intro: "(+) Adds an extra round to a routine",
                position: 'left'
              },
              {
                element: '#wStep8',
                intro: "These options delete current step or round. You cannot delete your only step or round",
                position: 'right'
              },
              {
                element: '#FinishStep',
                intro: "This option stores the pads selected in the simulator as a step",
                position: 'top'
              },
              {
                element: '#FinishRoutineButton',
                intro: "This option saves the custom routine! Name and description are provided afterwards. You are ready to start creating your own rotines!",
                position: 'top'
              }
              ]
            });
          }
          else {
            wizardguide.setOptions({
              steps: [
              {
                element: '#bannerImg',
                intro: 'Welcome to SkillCourt Wizard Tutorial',
                position: 'bottom'
              },
              {
                element: '#routineSwitch',
                intro: 'Switching to CUSTOM option allows you to create an unique routine based entirely on your customizations',
                position: 'left'
              },
              {
                element: '#w2Step3',
                intro: 'Set custon name for pre-defined based routine',
                position: 'right'
              },
              {
                element: '#w2Step4',
                intro: 'Choose pre-defined based routine to customize it',
                position: 'bottom'
              },
              {
                element: '#w2Step5',
                intro: 'Set the play time for the routine in minutes',
                position: 'left'
              },
              {
                element: '#difficultyRadio',
                intro: 'Set the difficulty of the routine',
                position: 'bottom'
              },
              {
                element: '#timedRoundsCheckbox',
                intro: 'If checked, allows you to put a time limit per round to the player',
                position: 'right'
              },
              {
                element: '#w2Step8',
                intro: 'When checked, this option allows the coach to remove a wall from the simulator',
                position: 'bottom'
              },
              {
                element: '#w2Step9',
                intro: 'Set brief description for the routine to be shown to the player',
                position: 'left'
              },
              {
                element: '#w2Step10',
                intro: 'This option saves the customized default routine! It is ready to be assigned to a player afterwards. You are ready to start creating your own rotines!',
                position: 'top'
              }
              ]
            });
          }
        }
        catch (error) {
          if (error.name === 'ReferenceError') {
          }
        }
  }), 500);