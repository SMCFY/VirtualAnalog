/*
  ==============================================================================

    This file was auto-generated!

    It contains the basic framework code for a JUCE plugin processor.

  ==============================================================================
*/

#ifndef PLUGINPROCESSOR_H_INCLUDED
#define PLUGINPROCESSOR_H_INCLUDED

#include "../JuceLibraryCode/JuceHeader.h"
#include "wdfJTM45Tree.hpp"
#include "../Libs/r8brain-free-src/CDSPResampler.h"
//==============================================================================
/**
*/
class Jtm45pluginAudioProcessor  : public AudioProcessor
{
public:
    //==============================================================================
    Jtm45pluginAudioProcessor();
    ~Jtm45pluginAudioProcessor();

    //==============================================================================
    void prepareToPlay (double sampleRate, int samplesPerBlock) override;
    void releaseResources() override;

   #ifndef JucePlugin_PreferredChannelConfigurations
    bool isBusesLayoutSupported (const BusesLayout& layouts) const override;
   #endif

    void processBlock (AudioSampleBuffer&, MidiBuffer&) override;

    //==============================================================================
    AudioProcessorEditor* createEditor() override;
    bool hasEditor() const override;

    //==============================================================================
    const String getName() const override;

    bool acceptsMidi() const override;
    bool producesMidi() const override;
    double getTailLengthSeconds() const override;

    //==============================================================================
    int getNumPrograms() override;
    int getCurrentProgram() override;
    void setCurrentProgram (int index) override;
    const String getProgramName (int index) override;
    void changeProgramName (int index, const String& newName) override;

    //==============================================================================
    void getStateInformation (MemoryBlock& destData) override;
    void setStateInformation (const void* data, int sizeInBytes) override;

private:
    wdfJTM45Tree JTM45;
    AudioParameterFloat* gain;
    AudioParameterFloat* volume;


    // sample conversion things 
    r8b::CDSPResampler24* upSmplr24 = NULL;
    r8b::CDSPResampler24* downSmplr24 = NULL;
    
    double* upBuf = NULL;
    double* downBuf = NULL;
    
    int blockSize;
    double outputSampleRate;
    double inputSampleRate;
    double treeSampleRate;
    double outputBitDepth;
    double oversamplingRatio;
    //==============================================================================
    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (Jtm45pluginAudioProcessor)
};


#endif  // PLUGINPROCESSOR_H_INCLUDED
