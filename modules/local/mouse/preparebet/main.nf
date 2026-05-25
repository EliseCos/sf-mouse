process MOUSE_PREPAREBET {
    tag "$meta.id"
    label 'process_high'

    container "scilus/scilus:2.2.0"

    input:
        tuple val(meta), path(anat)
    output:
        tuple val(meta), path("*_n4_second.nii.gz")          , emit: betready
        path "versions.yml"                                  , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """

    N4BiasFieldCorrection -d 3 -i ${anat} -o ${prefix}__n4_first.nii.gz -s 4 -c [20x20x10,1e-6]
    N4BiasFieldCorrection -d 3 -i ${prefix}__n4_first.nii.gz -o ${prefix}__n4_second.nii.gz -s 2 -c [30x20x10,1e-6]


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
    END_VERSIONS
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    N4BiasFieldCorrection -h

    touch ${prefix}__n4_second.nii.gz

    cat <<-END_VERSIONS > versions.yml
    ants: \$(N4BiasFieldCorrection --version 2>&1 | sed -n 's/ANTs Version: v\\([0-9.]\\+\\)/\\1/p')
    END_VERSIONS
    """
}
