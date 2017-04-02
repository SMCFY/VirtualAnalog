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
    addParameter (gain = new AudioParameterFloat ("gain","Gain",0.f,1.0f,0.5f));
    addParameter (volume = new AudioParameterFloat ("volume","Volume",0.f,1.0f,0.5f));
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
    JTM45.initTree();
    JTM45.adaptTree();
    
    upSmplr24 = new r8b::CDSPResampler24(sampleRate, JTM45.wdfTree::getSamplerate(), samplesPerBlock); //BS TODO
    downSmplr24 = new r8b::CDSPResampler24(JTM45.wdfTree::getSamplerate(), sampleRate, samplesPerBlock); //BS TODO
    
    inputSampleRate = sampleRate;
    outputSampleRate = sampleRate;
    
    oversamplingRatio = JTM45.wdfTree::getSamplerate() / sampleRate;
    
    size_t downBufSize = ceil(oversamplingRatio*samplesPerBlock);
    
    upBuf = new double[samplesPerBlock]; //BS TODO
    downBuf = new double[downBufSize]; //BS TODO
    
//    JTM45.wdfTree::setSamplerate(sampleRate);
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


    for (int i = totalNumInputChannels; i < totalNumOutputChannels; ++i)
        buffer.clear (i, 0, buffer.getNumSamples());

    JTM45.setParam(0, *volume);
    JTM45.setParam(1, *gain);
    
     // input
    for (int sample = 0; sample < buffer.getNumSamples(); sample++)
    {
        upBuf[sample] = (double) buffer.getSample(0, sample);
        upBuf[sample] += (double) buffer.getSample(1, sample);
        upBuf[sample] /= 2;
    }
    
    double* upDataPtr;
    
     
    int numUpSamples = upSmplr24->process(upBuf, buffer.getNumSamples(), upDataPtr);
    
    // WDF
    for (int sample = 0; sample < numUpSamples; sample++)
    {
        float inVoltage = upDataPtr[sample];
        
        JTM45.setInputValue(inVoltage);
        JTM45.cycleWave();
        downBuf[sample] = { (float)(JTM45.getOutputValue()) };
    }
    
    
    double* downDataPtr;
    
    int numDownSamples = downSmplr24->process(downBuf, numUpSamples, downDataPtr);
    float outVoltage = 0;
    
    float* left = buffer.getWritePointer (0);
    float* right = buffer.getWritePointer (1);
    
    // output
    for (int sample = 0; sample < numDownSamples; sample++)
    {
        outVoltage = { (float)(downDataPtr[sample]) };
        
        left[sample] = outVoltage;
        right[sample] = outVoltage;
    }
    
    /*
    float* left = buffer.getWritePointer (0);
    float* right = buffer.getWritePointer (1);
    for (int i = 0; i < buffer.getNumSamples(); i++){
        float sample = (left[i] + right[i])/2.0f;
        JTM45.setInputValue(sample);
        JTM45.cycleWave();
        left[i] = JTM45.getOutputValue();
        right[i] = JTM45.getOutputValue();
    }
     */
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
    MemoryOutputStream (destData, true).writeFloat(*gain);
    MemoryOutputStream (destData, true).writeFloat(*volume);
}

void Jtm45pluginAudioProcessor::setStateInformation (const void* data, int sizeInBytes)
{
    // You should use this method to restore your parameters from this memory block,
    // whose contents will have been created by the getStateInformation() call.
    MemoryInputStream stream (data, static_cast<size_t>(sizeInBytes), false);
    *gain = stream.readFloat();
    *volume = stream.readFloat();
}

//==============================================================================
// This creates new instances of the plugin..
AudioProcessor* JUCE_CALLTYPE createPluginFilter()
{
    return new Jtm45pluginAudioProcessor();
}
