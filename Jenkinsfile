#!groovy

node {
    properties([
        parameters([
            gitTagVersionInput()
        ])
    ])

  runDefaultDockerPipeline currentBuild: currentBuild, imageName: "timoreymann/mcsrvod", tag: params.Version
}
