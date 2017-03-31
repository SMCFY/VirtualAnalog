/*
  ==============================================================================

    This file was auto-generated!

    It contains the basic framework code for a JUCE plugin editor.

  ==============================================================================
*/

#ifndef PLUGINEDITOR_H_INCLUDED
#define PLUGINEDITOR_H_INCLUDED

#include "../JuceLibraryCode/JuceHeader.h"
#include "PluginProcessor.h"


//==============================================================================
/**
*/
class Jtm45pluginAudioProcessorEditor  : public AudioProcessorEditor
{
public:
    Jtm45pluginAudioProcessorEditor (Jtm45pluginAudioProcessor&);
    ~Jtm45pluginAudioProcessorEditor();

    //==============================================================================
    void paint (Graphics&) override;
    void resized() override;

private:
    // This reference is provided as a quick way for your editor to
    // access the processor object that created it.
    Jtm45pluginAudioProcessor& processor;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (Jtm45pluginAudioProcessorEditor)
};


#endif  // PLUGINEDITOR_H_INCLUDED
