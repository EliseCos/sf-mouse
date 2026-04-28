include { MOUSE_PREPAREBET } from '../../../modules/local/mouse/preparebet/main.nf'
include { MOUSE_BRAINEXTRACTION } from '../../../modules/local/mouse/brainextraction/main.nf'
include { MOUSE_CONVERTBET } from '../../../modules/local/mouse/convertbet/main.nf'

workflow BET {

    take:
        ch_bet           // channel: [ val(meta), dwi, bval, b0, mask]

    main:

        ch_versions = Channel.empty()
        ch_multiqc_files = Channel.empty()


        MOUSE_PREPAREBET(ch_bet)

        MOUSE_BRAINEXTRACTION(MOUSE_PREPAREBET.out.betready)

        MOUSE_CONVERTBET(MOUSE_BRAINEXTRACTION.out.mask)


    emit:
        mask = MOUSE_CONVERTBET.out.mask                     // channel: [ val(meta), mask ]
        mqc                 = ch_multiqc_files              // channel: [ val(meta), mqc ]
        versions            = ch_versions                   // channel: [ versions.yml ]
}
