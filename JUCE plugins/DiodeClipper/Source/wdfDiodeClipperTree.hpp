/*

*/


#pragma once
#include "rt-wdf/rt-wdf.h"


using namespace arma;

class wdfDiodeClipperTree : public wdfTree {

private:
  const float r1 = 2.2e3;
  const float c1 = 0.01e-6;

    std::unique_ptr<wdfTerminatedResVSource> Vin;
    std::unique_ptr<wdfTerminatedCap> Cap1;
    std::unique_ptr<wdfTerminatedParallel> subtree;

    std::string treeName = "Diode Clipper - 44100 Hz";

public:
    wdfDiodeClipperTree( ) {

        setSamplerate( 44100 );

        paramData inputGain;
        inputGain.name = "Input Gain";
        inputGain.ID = 0;
        inputGain.type = doubleParam;
        inputGain.value = 0.1;
        inputGain.units = " ";
        inputGain.lowLim = 0;
        inputGain.highLim = 2;
        params.push_back(inputGain);

        Vin.reset(new wdfTerminatedResVSource(0,r1));
        Cap1.reset(new wdfTerminatedCap(c1,1));
        subtree.reset(new wdfTerminatedParallel(Vin.get(), Cap1.get()));
        subtreeCount = 1;
        subtreeEntryNodes = new wdfTreeNode*[subtreeCount];

        root.reset( new wdfRootNL(subtreeCount,{DIODE_AP}, 1) );
        Rp = new double[subtreeCount] ();
    }

    ~wdfDiodeClipperTree() {
        delete subtreeEntryNodes;
        root.reset();
        delete Rp;
    }

    const char* getTreeIdentifier() {
        return treeName.c_str();
    }

    int setRootMatrData( matData* rootMats, double *Rp ) {
        return 0;
    }

    void setInputValue(double signalIn) {
        Vin->Vs = signalIn;
    }

    double getOutputValue() {
        return subtree->upPort->getPortVoltage();
    }

    void setParam(size_t paramID, double paramValue) {
        if (paramID == 0) {
            params[0].value = paramValue;
        }
    }
};
