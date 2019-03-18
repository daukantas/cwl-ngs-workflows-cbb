#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

label: Phantompeakqualtools
doc: This package computes informative enrichment and quality measures for ChIP-seq/DNase-seq/FAIRE-seq/MNase-seq data

requirements:
  InlineJavascriptRequirement: {}

hints:
  - $import: phantompeakqualtools.yml

inputs:
  c:
    type: File
    inputBinding:
      position: 1
      prefix: -c=
      separate: false
    doc: |
      Input bam file.
  savp:
    type: string
    inputBinding:
      position: 2
      prefix: -savp=
      separate: false
  out:
    type: string
    inputBinding:
      position: 3
      prefix: -out=
      separate: false

outputs:
  output_savp:
    type: File
    outputBinding:
      glob: $(inputs.savp)
  output_out:
    type: File
    outputBinding:
      glob: $(inputs.out)

baseCommand: ["run_spp.R", "-rf"]

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-4108-5982
    s:email: mailto:r78v10a07@gmail.com
    s:name: Roberto Vera Alvarez

s:codeRepository: https://github.com/kundajelab/phantompeakqualtools
s:license: https://spdx.org/licenses/OPL-1.0

$namespaces:
  s: http://schema.org/

$schemas:
  - http://schema.org/docs/schema_org_rdfa.html