process MOUSE_CONVERTJSON {
    label 'process_high'
 
    container "scilus/scilpy:2.2.0_cpu"

    input:
        tuple val(meta), path(stats), path(script_json)
    output:
        tuple val(meta), path("*__stats_reorganized.json")  , emit: stats_reorganized
        path "versions.yml"      , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """

    python $script_json $stats ${prefix}__stats_reorganized.json

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        scilpy: \$(uv pip -q -n list | grep scilpy | tr -s ' ' | cut -d' ' -f2)
    END_VERSIONS
    """

    stub:
    """
    touch ${prefix}__stats_reorganized.json

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        scilpy: \$(uv pip -q -n list | grep scilpy | tr -s ' ' | cut -d' ' -f2)
    END_VERSIONS
    """
}