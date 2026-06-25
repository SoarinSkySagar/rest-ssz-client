import results
export results

type
  Fork* = enum
    Paris
    Shanghai
    Cancun
    Prague
    Osaka
    Amsterdam

func parseFork*(value: string): Opt[Fork] =
  case value
  of "paris":     Opt.some(Paris)
  of "shanghai":  Opt.some(Shanghai)
  of "cancun":    Opt.some(Cancun)
  of "prague":    Opt.some(Prague)
  of "osaka":     Opt.some(Osaka)
  of "amsterdam": Opt.some(Amsterdam)
  else:           Opt.none(Fork)
