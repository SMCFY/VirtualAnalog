/*
  ==============================================================================

    This file was auto-generated!

    It contains the basic framework code for a JUCE plugin editor.

  ==============================================================================
*/

#include "PluginProcessor.h"
#include "PluginEditor.h"


//==============================================================================
Jtm45pluginAudioProcessorEditor::Jtm45pluginAudioProcessorEditor (Jtm45pluginAudioProcessor& p)
    : AudioProcessorEditor (&p), processor (p)
{
    // Make sure that before the constructor has finished, you've set the
    // editor's size to whatever you need it to be.
    setSize (100, 100);
}

Jtm45pluginAudioProcessorEditor::~Jtm45pluginAudioProcessorEditor()
{
}

//==============================================================================
void Jtm45pluginAudioProcessorEditor::paint (Graphics& g)
{
    g.fillAll (Colours::white);

    g.setColour (Colours::black);
    g.setFont (15.0f);
    g.drawFittedText ("JTM45 Pre-Amp", getLocalBounds(), Justification::centred, 1);
}

void Jtm45pluginAudioProcessorEditor::resized()
{
    // This is generally where you'll want to lay out the positions of any
    // subcomponents in your editor..
}
