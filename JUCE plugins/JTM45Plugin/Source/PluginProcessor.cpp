/*
  ==============================================================================

    This file was auto-generated!

    It contains the basic framework code for a JUCE plugin processor.

  ==============================================================================
*/

#include "PluginProcessor.h"
#include "PluginEditor.h"


//==============================================================================
Jtm45pluginAudioProcessor::Jtm45pluginAudioProcessor()
#ifndef JucePlugin_PreferredChannelConfigurations
     : AudioProcessor (BusesProperties()
                     #if ! JucePlugin_IsMidiEffect
                      #if ! JucePlugin_IsSynth
                       .withInput  ("Input",  AudioChannelSet::stereo(), true)
                      #endif
                       .withOutput ("Output", AudioChannelSet::stereo(), true)
                     #endif
                       )
#endif
{

    addParameter (inputGain = new AudioParameterFloat ("inputGain", // parameterID,
                                                  "Input Gain", // parameter name
                                                  0.0001f,   // minimum value
                                                  0.9999f,   // maximum value
                                                  0.1f));    // default value
    addParameter (volume = new AudioParameterFloat ("volume","Volume",0.0001f,0.9999f,0.1f));
}

Jtm45pluginAudioProcessor::~Jtm45pluginAudioProcessor()
{
}

//==============================================================================
const String Jtm45pluginAudioProcessor::getName() const
{
    return JucePlugin_Name;
}

bool Jtm45pluginAudioProcessor::acceptsMidi() const
{
   #if JucePlugin_WantsMidiInput
    return true;
   #else
    return false;
   #endif
}

bool Jtm45pluginAudioProcessor::producesMidi() const
{
   #if JucePlugin_ProducesMidiOutput
    return true;
   #else
    return false;
   #endif
}

double Jtm45pluginAudioProcessor::getTailLengthSeconds() const
{
    return 0.0;
}

int Jtm45pluginAudioProcessor::getNumPrograms()
{
    return 1;   // NB: some hosts don't cope very well if you tell them there are 0 programs,
                // so this should be at least 1, even if you're not really implementing programs.
}

int Jtm45pluginAudioProcessor::getCurrentProgram()
{
    return 0;
}

void Jtm45pluginAudioProcessor::setCurrentProgram (int index)
{
}

const String Jtm45pluginAudioProcessor::getProgramName (int index)
{
    return String();
}

void Jtm45pluginAudioProcessor::changeProgramName (int index, const String& newName)
{
}

//==============================================================================
void Jtm45pluginAudioProcessor::prepareToPlay (double sampleRate, int samplesPerBlock)
{
    // Use this method as the place to do any pre-playback
    // initialisation that you need..
    jtm45.initTree();
    jtm45.wdfTree::setSamplerate(sampleRate);
    jtm45.adaptTree();
}

void Jtm45pluginAudioProcessor::releaseResources()
{
    // When playback stops, you can use this as an opportunity to free up any
    // spare memory, etc.
}

#ifndef JucePlugin_PreferredChannelConfigurations
bool Jtm45pluginAudioProcessor::isBusesLayoutSupported (const BusesLayout& layouts) const
{
  #if JucePlugin_IsMidiEffect
    ignoreUnused (layouts);
    return true;
  #else
    // This is the place where you check if the layout is supported.
    // In this template code we only support mono or stereo.
    if (layouts.getMainOutputChannelSet() != AudioChannelSet::mono()
     && layouts.getMainOutputChannelSet() != AudioChannelSet::stereo())
        return false;

    // This checks if the input layout matches the output layout
   #if ! JucePlugin_IsSynth
    if (layouts.getMainOutputChannelSet() != layouts.getMainInputChannelSet())
        return false;
   #endif

    return true;
  #endif
}
#endif

void Jtm45pluginAudioProcessor::processBlock (AudioSampleBuffer& buffer, MidiBuffer& midiMessages)
{
    const int totalNumInputChannels  = getTotalNumInputChannels();
    const int totalNumOutputChannels = getTotalNumOutputChannels();

    // In case we have more outputs than inputs, this code clears any output
    // channels that didn't contain input data, (because these aren't
    // guaranteed to be empty - they may contain garbage).
    // This is here to avoid people getting screaming feedback
    // when they first compile a plugin, but obviously you don't need to keep
    // this code if your algorithm always overwrites all the output channels.
    for (int i = totalNumInputChannels; i < totalNumOutputChannels; ++i)
        buffer.clear (i, 0, buffer.getNumSamples());

    jtm45.setParam(0, *inputGain);
    jtm45.setParam(1, *volume);

    float* channelData1 = buffer.getWritePointer (0);
    float* channelData2 = buffer.getWritePointer (1);
        for (int i = 0; i < buffer.getNumSamples(); i++){
            float sample = (channelData1[i] + channelData2[i])/2.0f;
            jtm45.setInputValue(sample);
            jtm45.cycleWave();
            channelData1[i] = jtm45.getOutputValue();
            channelData2[i] = jtm45.getOutputValue();
        }
}

//==============================================================================
bool Jtm45pluginAudioProcessor::hasEditor() const
{
    return true; // (change this to false if you choose to not supply an editor)
}

AudioProcessorEditor* Jtm45pluginAudioProcessor::createEditor()
{
    return new Jtm45pluginAudioProcessorEditor (*this);
}

//==============================================================================
void Jtm45pluginAudioProcessor::getStateInformation (MemoryBlock& destData)
{
    // You should use this method to store your parameters in the memory block.
    // You could do that either as raw data, or use the XML or ValueTree classes
    // as intermediaries to make it easy to save and load complex data.
    MemoryOutputStream (destData, true).writeFloat(*inputGain);
    MemoryOutputStream (destData, true).writeFloat(*volume);
}

void Jtm45pluginAudioProcessor::setStateInformation (const void* data, int sizeInBytes)
{
    // You should use this method to restore your parameters from this memory block,
    // whose contents will have been created by the getStateInformation() call.
    MemoryInputStream stream (data, static_cast<size_t>(sizeInBytes), false);
    *inputGain = stream.readFloat();
    *volume = stream.readFloat();
}

//==============================================================================
// This creates new instances of the plugin..
AudioProcessor* JUCE_CALLTYPE createPluginFilter()
{
    return new Jtm45pluginAudioProcessor();
}
