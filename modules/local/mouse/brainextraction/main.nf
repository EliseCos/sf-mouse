process MOUSE_BRAINEXTRACTION {
    tag "$meta.id"
    label 'process_high'

    container "scilus/antspynet:dev"

    input:
        tuple val(meta), path(anat)
    output:
        tuple val(meta), path("*__mask.nii.gz")      , emit: mask
        path "versions.yml"                          , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"

    """
    antsMouseBrainExtraction $anat ${prefix}__mask.nii.gz

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        scilpy: \$(uv pip -q -n list | grep scilpy | tr -s ' ' | cut -d' ' -f2)
    END_VERSIONS
    """

    stub:
    """
    fslmaths
    scil_volume_math -h

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        scilpy: \$(uv pip -q -n list | grep scilpy | tr -s ' ' | cut -d' ' -f2)
    END_VERSIONS
    """
}