/*
  ==============================================================================

    This file was auto-generated!

    It contains the basic framework code for a JUCE plugin processor.

  ==============================================================================
*/

#include "PluginProcessor.h"
#include "PluginEditor.h"


//==============================================================================
TonestackPluginAudioProcessor::TonestackPluginAudioProcessor()
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
    addParameter (bass = new AudioParameterFloat ("bass", // parameterID,
                                                  "Bass", // parameter name
                                                  0.0001f,   // minimum value
                                                  0.9999f,   // maximum value
                                                  0.5f));    // default value
    addParameter (middle = new AudioParameterFloat ("middle","Middle",0.0001f,0.9999f,0.5f));
    addParameter (treble = new AudioParameterFloat ("treble","Treble",0.0001f,0.9999f,0.5f));
    }
    
TonestackPluginAudioProcessor::~TonestackPluginAudioProcessor()
{
}

//==============================================================================
const String TonestackPluginAudioProcessor::getName() const
{
    return JucePlugin_Name;
}

bool TonestackPluginAudioProcessor::acceptsMidi() const
{
   #if JucePlugin_WantsMidiInput
    return true;
   #else
    return false;
   #endif
}

bool TonestackPluginAudioProcessor::producesMidi() const
{
   #if JucePlugin_ProducesMidiOutput
    return true;
   #else
    return false;
   #endif
}

double TonestackPluginAudioProcessor::getTailLengthSeconds() const
{
    return 0.0;
}

int TonestackPluginAudioProcessor::getNumPrograms()
{
    return 1;   // NB: some hosts don't cope very well if you tell them there are 0 programs,
                // so this should be at least 1, even if you're not really implementing programs.
}

int TonestackPluginAudioProcessor::getCurrentProgram()
{
    return 0;
}

void TonestackPluginAudioProcessor::setCurrentProgram (int index)
{
}

const String TonestackPluginAudioProcessor::getProgramName (int index)
{
    return String();
}

void TonestackPluginAudioProcessor::changeProgramName (int index, const String& newName)
{
}

//==============================================================================
void TonestackPluginAudioProcessor::prepareToPlay (double sampleRate, int samplesPerBlock)
{
    // Use this method as the place to do any pre-playback
    // initialisation that you need..
    tonestack.initTree();
    tonestack.wdfTree::setSamplerate(sampleRate);
    tonestack.adaptTree();
}

void TonestackPluginAudioProcessor::releaseResources()
{
    // When playback stops, you can use this as an opportunity to free up any
    // spare memory, etc.
}

#ifndef JucePlugin_PreferredChannelConfigurations
bool TonestackPluginAudioProcessor::isBusesLayoutSupported (const BusesLayout& layouts) const
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

void TonestackPluginAudioProcessor::processBlock (AudioSampleBuffer& buffer, MidiBuffer& midiMessages)
{
    const int totalNumInputChannels  = getTotalNumInputChannels();
    const int totalNumOutputChannels = getTotalNumOutputChannels();

    for (int i = totalNumInputChannels; i < totalNumOutputChannels; ++i)
        buffer.clear (i, 0, buffer.getNumSamples());

    tonestack.setParam(0, *bass);
    tonestack.setParam(1, *middle);
    tonestack.setParam(2, *treble);
    
    
    float* channelData1 = buffer.getWritePointer (0);
    float* channelData2 = buffer.getWritePointer (1);
        for (int i = 0; i < buffer.getNumSamples(); i++){
            float sample = (channelData1[i] + channelData2[i])/2.0f;
            tonestack.setInputValue(sample);
            tonestack.cycleWave();
            channelData1[i] = tonestack.getOutputValue();
            channelData2[i] = tonestack.getOutputValue();
        }
}

//==============================================================================
bool TonestackPluginAudioProcessor::hasEditor() const
{
    return true; // (change this to false if you choose to not supply an editor)
}

AudioProcessorEditor* TonestackPluginAudioProcessor::createEditor()
{
    return new TonestackPluginAudioProcessorEditor (*this);
}

//==============================================================================
void TonestackPluginAudioProcessor::getStateInformation (MemoryBlock& destData)
{
    // You should use this method to store your parameters in the memory block.
    // You could do that either as raw data, or use the XML or ValueTree classes
    // as intermediaries to make it easy to save and load complex data.
    MemoryOutputStream (destData, true).writeFloat(*bass);
    MemoryOutputStream (destData, true).writeFloat(*middle);
    MemoryOutputStream (destData, true).writeFloat(*treble);
}

void TonestackPluginAudioProcessor::setStateInformation (const void* data, int sizeInBytes)
{
    // You should use this method to restore your parameters from this memory block,
    // whose contents will have been created by the getStateInformation() call.
    MemoryInputStream stream (data, static_cast<size_t>(sizeInBytes), false);
    *bass = stream.readFloat();
    *middle = stream.readFloat();
    *treble = stream.readFloat();
    
}

//==============================================================================
// This creates new instances of the plugin..
AudioProcessor* JUCE_CALLTYPE createPluginFilter()
{
    return new TonestackPluginAudioProcessor();
}
