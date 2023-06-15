---
title: Third-Party Logging And Tracing Integration
---

## Overview

To effectively monitor the performance of your EOS-based blockchain node(s), it is essential to utilize telemetry tools. In the EOS ecosystem, there are two recommended telemetry tools available for integration:

* [Deep-mind logger](10_deep-mind-logger.md)
* [Zipkin tracer](20_zipkin-tracer.md)

## Performance Considerations

It is important to note that utilizing telemetry tools comes with a trade-off. When these tools are activated, they will have an impact on the performance of your nodeos node. The extent of this impact can vary depending on several factors, but it is inevitable that there will be some performance degradation. Consequently, it is advisable to exercise caution when enabling these tools and only activate them when you genuinely require the detailed information they offer. Once the desired monitoring is complete, it is recommended to deactivate the telemetry tools to minimize any adverse effects on performance.
