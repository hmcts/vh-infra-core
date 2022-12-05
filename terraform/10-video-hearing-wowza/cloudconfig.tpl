#cloud-config
apt_sources:
  - source: "deb [arch=amd64 trusted=yes] https://packages.microsoft.com/ubuntu/18.04/prod bionic main"
package_upgrade: true
packages:
  - blobfuse
  - fuse
write_files:
  - owner: wowza:wowza
    path: /home/wowza/Application.xml
    content: |
        <?xml version="1.0" encoding="UTF-8"?>
        <Root version="1">
                <Application>
                        <Name>vh-recording-app</Name>
                        <AppType>Live</AppType>
                        <Description>Video Hearings Application for Audio Recordings</Description>
                        <!-- Uncomment to set application level timeout values <ApplicationTimeout>60000</ApplicationTimeout><PingTimeout>12000</PingTimeout><ValidationFrequency>8000</ValidationFrequency><MaximumPendingWriteBytes>0</MaximumPendingWriteBytes><MaximumSetBufferTime>60000</MaximumSetBufferTime><MaximumStorageDirDepth>25</MaximumStorageDirDepth> -->
                        <Connections>
                                <AutoAccept>true</AutoAccept>
                                <AllowDomains></AllowDomains>
                        </Connections>
                        <!-- StorageDir path variables $${com.wowza.wms.AppHome} - Application home directory $${com.wowza.wms.ConfigHome} - Configuration home directory $${com.wowza.wms.context.VHost} - Virtual host name $${com.wowza.wms.context.VHostConfigHome} - Virtual host home directory $${com.wowza.wms.context.Application} - Application name $${com.wowza.wms.context.ApplicationInstance} - Application instance name -->
                        <Streams>
                                <StreamType>live</StreamType>
                                <StorageDir>$${com.wowza.wms.context.VHostConfigHome}/content/vh-recording-app</StorageDir>
                                <KeyDir>$${com.wowza.wms.context.VHostConfigHome}/keys</KeyDir>
                                <!-- LiveStreamPacketizers (separate with commas): cupertinostreamingpacketizer, smoothstreamingpacketizer, sanjosestreamingpacketizer, mpegdashstreamingpacketizer, cupertinostreamingrepeater, smoothstreamingrepeater, sanjosestreamingrepeater, mpegdashstreamingrepeater, dvrstreamingpacketizer, dvrstreamingrepeater -->
                                <LiveStreamPacketizers></LiveStreamPacketizers>
                                <!-- Properties defined here will override any properties defined in conf/Streams.xml for any streams types loaded by this application -->
                                <Properties></Properties>
                        </Streams>
                        <Transcoder>
                                <!-- To turn on transcoder set to: transcoder -->
                                <LiveStreamTranscoder></LiveStreamTranscoder>
                                <!-- [templatename].xml or $${SourceStreamName}.xml -->
                                <Templates>$${SourceStreamName}.xml,transrate.xml</Templates>
                                <ProfileDir>$${com.wowza.wms.context.VHostConfigHome}/transcoder/profiles</ProfileDir>
                                <TemplateDir>$${com.wowza.wms.context.VHostConfigHome}/transcoder/templates</TemplateDir>
                                <Properties></Properties>
                        </Transcoder>
                        <DVR>
                                <!-- As a single server or as an origin, use dvrstreamingpacketizer in LiveStreamPacketizers above -->
                                <!-- Or, in an origin-edge configuration, edges use dvrstreamingrepeater in LiveStreamPacketizers above -->
                                <!-- As an origin, also add dvrchunkstreaming to HTTPStreamers below -->
                                <!-- If this is a dvrstreamingrepeater, define Application/Repeater/OriginURL to point back to the origin -->
                                <!-- To turn on DVR recording set Recorders to dvrrecorder. This works with dvrstreamingpacketizer -->
                                <Recorders></Recorders>
                                <!-- As a single server or as an origin, set the Store to dvrfilestorage-->
                                <!-- edges should have this empty -->
                                <Store></Store>
                                <!-- Window Duration is length of live DVR window in seconds. 0 means the window is never trimmed. -->
                                <WindowDuration>0</WindowDuration>
                                <!-- Storage Directory is top level location where dvr is stored. e.g. c:/temp/dvr -->
                                <StorageDir>$${com.wowza.wms.context.VHostConfigHome}/dvr</StorageDir>
                                <!-- valid ArchiveStrategy values are append, version, delete -->
                                <ArchiveStrategy>append</ArchiveStrategy>
                                <!-- Properties for DVR -->
                                <Properties></Properties>
                        </DVR>
                        <TimedText>
                                <!-- VOD caption providers (separate with commas): vodcaptionprovidermp4_3gpp, vodcaptionproviderttml, vodcaptionproviderwebvtt, vodcaptionprovidersrt, vodcaptionproviderscc -->
                                <VODTimedTextProviders>vodcaptionprovidermp4_3gpp</VODTimedTextProviders>
                                <!-- Properties for TimedText -->
                                <Properties></Properties>
                        </TimedText>
                        <!-- HTTPStreamers (separate with commas): cupertinostreaming, smoothstreaming, sanjosestreaming, mpegdashstreaming, dvrchunkstreaming -->
                        <HTTPStreamers>cupertinostreaming,smoothstreaming,sanjosestreaming,mpegdashstreaming</HTTPStreamers>
                        <MediaCache>
                                <MediaCacheSourceList></MediaCacheSourceList>
                        </MediaCache>
                        <SharedObjects>
                                <StorageDir>$${com.wowza.wms.context.VHostConfigHome}/applications/$${com.wowza.wms.context.Application}/sharedobjects/$${com.wowza.wms.context.ApplicationInstance}</StorageDir>
                        </SharedObjects>
                        <Client>
                                <IdleFrequency>-1</IdleFrequency>
                                <Access>
                                        <StreamReadAccess>*</StreamReadAccess>
                                        <StreamWriteAccess>*</StreamWriteAccess>
                                        <StreamAudioSampleAccess></StreamAudioSampleAccess>
                                        <StreamVideoSampleAccess></StreamVideoSampleAccess>
                                        <SharedObjectReadAccess>*</SharedObjectReadAccess>
                                        <SharedObjectWriteAccess>*</SharedObjectWriteAccess>
                                </Access>
                        </Client>
                        <RTP>
                                <!-- RTP/Authentication/[type]Methods defined in Authentication.xml. Default setup includes; none, basic, digest -->
                                <Authentication>
                                        <PublishMethod>block</PublishMethod>
                                        <PlayMethod>none</PlayMethod>
                                </Authentication>
                                <!-- RTP/AVSyncMethod. Valid values are: senderreport, systemclock, rtptimecode -->
                                <AVSyncMethod>senderreport</AVSyncMethod>
                                <MaxRTCPWaitTime>0</MaxRTCPWaitTime>
                                <IdleFrequency>75</IdleFrequency>
                                <RTSPSessionTimeout>90000</RTSPSessionTimeout>
                                <RTSPMaximumPendingWriteBytes>0</RTSPMaximumPendingWriteBytes>
                                <RTSPBindIpAddress></RTSPBindIpAddress>
                                <RTSPConnectionIpAddress>0.0.0.0</RTSPConnectionIpAddress>
                                <RTSPOriginIpAddress>127.0.0.1</RTSPOriginIpAddress>
                                <IncomingDatagramPortRanges>*</IncomingDatagramPortRanges>
                                <!-- Properties defined here will override any properties defined in conf/RTP.xml for any depacketizers loaded by this application -->
                                <Properties></Properties>
                        </RTP>
                        <WebRTC>
                                <!-- Enable WebRTC publishing to this application -->
                                <EnablePublish>false</EnablePublish>
                                <!-- Enable WebRTC playback from this application -->
                                <EnablePlay>false</EnablePlay>
                                <!-- Enable query of published stream names for this application -->
                                <EnableQuery>false</EnableQuery>
                                <!-- IP address, transport, and port used for WebRTC streaming. -->
                                <!--TCP format: [wowza-streaming-engine-external-ip-address],tcp,[port] -->
                                <!--UDP format: [wowza-streaming-engine-external-ip-address],udp -->
                                <IceCandidateIpAddresses>127.0.0.1,tcp,1935</IceCandidateIpAddresses>
                                <!-- Local IP address of the network card you want to use for WebRTC UDP traffic -->
                                <UDPBindAddress></UDPBindAddress>
                                <!-- Comma-deliniated list of audio codecs, in order of preference, for stream ingestion -->
                                <PreferredCodecsAudio>opus,vorbis,pcmu,pcma</PreferredCodecsAudio>
                                <!-- Comma-deliniated list of video codecs, in order of preference, for stream ingestion -->
                                <PreferredCodecsVideo>vp8,h264</PreferredCodecsVideo>
                                <!-- Enable WebRTC debug logging -->
                                <DebugLog>false</DebugLog>
                                <!-- Properties for WebRTC -->
                                <Properties></Properties>
                        </WebRTC>
                        <MediaCaster>
                                <RTP>
                                        <RTSP>
                                                <!-- udp, interleave -->
                                                <RTPTransportMode>interleave</RTPTransportMode>
                                        </RTSP>
                                </RTP>
                                <StreamValidator>
                                        <Enable>true</Enable>
                                        <ResetNameGroups>true</ResetNameGroups>
                                        <StreamStartTimeout>20000</StreamStartTimeout>
                                        <StreamTimeout>12000</StreamTimeout>
                                        <VideoStartTimeout>0</VideoStartTimeout>
                                        <VideoTimeout>0</VideoTimeout>
                                        <AudioStartTimeout>0</AudioStartTimeout>
                                        <AudioTimeout>0</AudioTimeout>
                                        <VideoTCToleranceEnable>false</VideoTCToleranceEnable>
                                        <VideoTCPosTolerance>3000</VideoTCPosTolerance>
                                        <VideoTCNegTolerance>-500</VideoTCNegTolerance>
                                        <AudioTCToleranceEnable>false</AudioTCToleranceEnable>
                                        <AudioTCPosTolerance>3000</AudioTCPosTolerance>
                                        <AudioTCNegTolerance>-500</AudioTCNegTolerance>
                                        <DataTCToleranceEnable>false</DataTCToleranceEnable>
                                        <DataTCPosTolerance>3000</DataTCPosTolerance>
                                        <DataTCNegTolerance>-500</DataTCNegTolerance>
                                        <AVSyncToleranceEnable>false</AVSyncToleranceEnable>
                                        <AVSyncTolerance>1500</AVSyncTolerance>
                                        <DebugLog>false</DebugLog>
                                </StreamValidator>
                                <!-- Properties defined here will override any properties defined in conf/MediaCasters.xml for any MediaCasters loaded by this applications -->
                                <Properties></Properties>
                        </MediaCaster>
                        <MediaReader>
                                <!-- Properties defined here will override any properties defined in conf/MediaReaders.xml for any MediaReaders loaded by this applications -->
                                <Properties></Properties>
                        </MediaReader>
                        <MediaWriter>
                                <!-- Properties defined here will override any properties defined in conf/MediaWriter.xml for any MediaWriter loaded by this applications -->
                                <Properties></Properties>
                        </MediaWriter>
                        <LiveStreamPacketizer>
                                <!-- Properties defined here will override any properties defined in conf/LiveStreamPacketizers.xml for any LiveStreamPacketizers loaded by this applications -->
                                <Properties></Properties>
                        </LiveStreamPacketizer>
                        <HTTPStreamer>
                                <!-- Properties defined here will override any properties defined in conf/HTTPStreamers.xml for any HTTPStreamer loaded by this applications -->
                                <Properties>
                                        <Property>
                                                <Name>httpCORSHeadersEnabled</Name>
                                                <Value>false</Value>
                                                <Type>Boolean</Type>
                                        </Property>
                                </Properties>
                        </HTTPStreamer>
                        <Manager>
                                <!-- Properties defined are used by the Manager -->
                                <Properties></Properties>
                        </Manager>
                        <Repeater>
                                <OriginURL></OriginURL>
                                <QueryString></QueryString>
                        </Repeater>
                        <StreamRecorder>
                                <Properties>
                                        <Property>
                                                <Name>streamRecorderFileVersionTemplate</Name>
                                                <Value>$${SourceStreamName}_$${RecordingStartTime}_$${SegmentNumber}</Value>
                                                <Type>String</Type>
                                        </Property>
                                        <Property>
                                                <Name>streamRecorderSegmentationType</Name>
                                                <Value>duration</Value>
                                                <Type>String</Type>
                                        </Property>
                                        <Property>
                                                <Name>streamRecorderSegmentDuration</Name>
                                                <Value>20000000</Value>
                                                <Type>long</Type>
                                        </Property>
                                </Properties>
                        </StreamRecorder>
                        <Modules>
                                <Module>
                                        <Name>base</Name>
                                        <Description>Base</Description>
                                        <Class>com.wowza.wms.module.ModuleCore</Class>
                                </Module>
                                <Module>
                                        <Name>logging</Name>
                                        <Description>Client Logging</Description>
                                        <Class>com.wowza.wms.module.ModuleClientLogging</Class>
                                </Module>
                                <Module>
                                        <Name>flvplayback</Name>
                                        <Description>FLVPlayback12</Description>
                                        <Class>com.wowza.wms.module.ModuleFLVPlayback</Class>
                                </Module>
                                <Module>
                                        <Name>ModuleCoreSecurity</Name>
                                        <Description>Core Security Module for Applications</Description>
                                        <Class>com.wowza.wms.module.ModuleCoreSecurity</Class>
                                </Module>
                                <Module>
                                        <Name>ModuleMediaWriterFileMover</Name>
                                        <Description>ModuleMediaWriterFileMover</Description>
                                        <Class>com.wowza.wms.module.ModuleMediaWriterFileMover</Class>
                                </Module>
                                <Module>
                                        <Name>ModuleAutoRecord</Name>
                                        <Description>ModuleAutoRecord</Description>
                                        <Class>com.wowza.wms.plugin.ModuleAutoRecord</Class>
                                </Module>
                        </Modules>
                        <!-- Properties defined here will be added to the IApplication.getProperties() and IApplicationInstance.getProperties() collections -->
                        <Properties>
                                <Property>
                                        <Name>securityPublishIPWhiteList</Name>
                                        <Value>*</Value>
                                        <Type>String</Type>
                                </Property>
                                <Property>
                                        <Name>securityPublishBlockDuplicateStreamNames</Name>
                                        <Value>true</Value>
                                        <Type>Boolean</Type>
                                </Property>
                                <Property>
                                        <Name>fileMoverDestinationPath</Name>
                                        <Value>/wowzadata/azurecopy</Value>
                                        <Type>String</Type>
                                </Property>
                                <Property>
                                        <Name>fileMoverDeleteOriginal</Name>
                                        <Value>true</Value>
                                        <Type>Boolean</Type>
                                </Property>
                                <Property>
                                        <Name>fileMoverVersionFile</Name>
                                        <Value>true</Value>
                                        <Type>Boolean</Type>
                                </Property>
                        </Properties>
                        <ApplicationTimeout>0</ApplicationTimeout>
                        <PingTimeout>0</PingTimeout>
                </Application>
        </Root>
  - owner: wowza:wowza
    path: /home/wowza/WowzaStreamingEngine/conf/Server.xml
    content: |
      <?xml version="1.0" encoding="UTF-8"?>
      <Root version="2">
              <Server>
                      <Name>Wowza Streaming Engine</Name>
                      <Description>Wowza Streaming Engine is robust, customizable, and scalable server software that powers reliable streaming of high-quality video and audio to any device, anywhere.</Description>
                      <RESTInterface>
                              <Enable>true</Enable>
                              <IPAddress>*</IPAddress>
                              <Port>8087</Port>
                              <!-- none, basic, digest, remotehttp, digestfile -->
                              <AuthenticationMethod>digestfile</AuthenticationMethod>
                              <DiagnosticURLEnable>true</DiagnosticURLEnable>
                              <SSLConfig>
                                      <Enable>true</Enable>
                                      <KeyStorePath>/usr/local/WowzaStreamingEngine/conf/ssl.wowza.jks</KeyStorePath>
                                      <KeyStorePassword>${certPassword}</KeyStorePassword>
                                      <KeyStoreType>JKS</KeyStoreType>
                                      <SSLProtocol>TLS</SSLProtocol>
                                      <Algorithm>SunX509</Algorithm>
                                      <CipherSuites></CipherSuites>
                                      <Protocols>TLSv1.2</Protocols>
                              </SSLConfig>
                              <IPWhiteList>*</IPWhiteList>
                              <IPBlackList></IPBlackList>
                              <EnableXMLFile>false</EnableXMLFile>
                              <DocumentationServerEnable>false</DocumentationServerEnable>
                              <DocumentationServerPort>8089</DocumentationServerPort>
                              <!-- none, basic, digest, remotehttp, digestfile -->
                              <DocumentationServerAuthenticationMethod>digestfile</DocumentationServerAuthenticationMethod>
                              <Properties>
                              </Properties>
                      </RESTInterface>
                      <CommandInterface>
                              <HostPort>
                                      <ProcessorCount>$${com.wowza.wms.TuningAuto}</ProcessorCount>
                                      <IpAddress>*</IpAddress>
                                      <Port>8083</Port>
                              </HostPort>
                      </CommandInterface>
                      <AdminInterface>
                              <!-- Objects exposed through JMX interface: Server, VHost, VHostItem, Application, ApplicationInstance, MediaCaster, Module, Client, MediaStream, SharedObject, Acceptor, IdleWorker -->
                              <ObjectList>Server,VHost,VHostItem,Application,ApplicationInstance,MediaCaster,Module,IdleWorker</ObjectList>
                      </AdminInterface>
                      <Stats>
                              <Enable>false</Enable>
                      </Stats>
                      <!-- JMXUrl: service:jmx:rmi://localhost:8084/jndi/rmi://localhost:8085/jmxrmi -->
                      <JMXRemoteConfiguration>
                              <Enable>false</Enable>
                              <IpAddress>$${com.wowza.cloud.platform.PLATFORM_METADATA_EXTERNAL_IP}</IpAddress> <!--changed for default cloud install. <IpAddress>localhost</IpAddress>--> <!-- set to localhost or internal ip address if behind NAT -->
                              <RMIServerHostName>$${com.wowza.cloud.platform.PLATFORM_METADATA_EXTERNAL_IP}</RMIServerHostName> <!--changed for default cloud install. <RMIServerHostName>localhost</RMIServerHostName>--> <!-- set to external ip address or domain name if behind NAT -->
                              <RMIConnectionPort>8084</RMIConnectionPort>
                              <RMIRegistryPort>8085</RMIRegistryPort>
                              <Authenticate>true</Authenticate>
                              <PasswordFile>$${com.wowza.wms.ConfigHome}/conf/jmxremote.password</PasswordFile>
                              <AccessFile>$${com.wowza.wms.ConfigHome}/conf/jmxremote.access</AccessFile>
                              <SSLSecure>false</SSLSecure>
                      </JMXRemoteConfiguration>
                      <UserAgents>Shockwave Flash|CFNetwork|MacNetwork/1.0 (Macintosh)</UserAgents>
                      <Streams>
                              <DefaultStreamPrefix>mp4</DefaultStreamPrefix>
                      </Streams>
                      <ServerListeners>
                              <ServerListener>
                                      <BaseClass>com.wowza.wms.module.ServerListenerTranscoderPreload</BaseClass>
                              </ServerListener> <!--changed for default cloud install. -->
                              <ServerListener>
                                      <BaseClass>com.wowza.wms.plugin.cloud.platform.env.ServerListenerVariables</BaseClass>
                              </ServerListener> <!--changed for default cloud install. -->
                              <ServerListener>
                                      <BaseClass>com.wowza.wms.mediacache.impl.MediaCacheServerListener</BaseClass>
                              </ServerListener>
                              <!--
                              <ServerListener>
                                      <BaseClass>com.wowza.wms.plugin.loadbalancer.ServerListenerLoadBalancerListener</BaseClass>
                              </ServerListener>
                              -->
                              <!--
                              <ServerListener>
                                      <BaseClass>com.wowza.wms.plugin.loadbalancer.ServerListenerLoadBalancerSender</BaseClass>
                              </ServerListener>
                              -->
                      </ServerListeners>
                      <VHostListeners>
                              <!--
                              <VHostListener>
                                      <BaseClass></BaseClass>
                              </VHostListener>
                              -->
                      </VHostListeners>
                      <HandlerThreadPool>
                              <PoolSize>$${com.wowza.wms.TuningAuto}</PoolSize>
                      </HandlerThreadPool>
                      <TransportThreadPool>
                              <PoolSize>$${com.wowza.wms.TuningAuto}</PoolSize>
                      </TransportThreadPool>
                      <RTP>
                              <DatagramStartingPort>6970</DatagramStartingPort>
                              <DatagramPortSharing>false</DatagramPortSharing>
                      </RTP>
                      <Manager>
                              <!-- Properties defined are used by the Manager -->
                              <Properties>
                              </Properties>
                      </Manager>
                      <Transcoder>
                              <PluginPaths>
                                      <QuickSync></QuickSync>
                              </PluginPaths>
                      </Transcoder>
                      <!-- Properties defined here will be added to the IServer.getProperties() collection -->
                      <Properties>
                      </Properties>
              </Server>
      </Root>
  - owner: wowza:wowza
    path: /usr/local/WowzaStreamingEngine/conf/Tune.xml
    content: |
      <?xml version="1.0" encoding="UTF-8"?>
      <Root>
            <Tune>
                <HeapSize>8192M</HeapSize>
                <GarbageCollector>$${com.wowza.wms.TuningGarbageCollectorG1Default}</GarbageCollector>
                <VMOptions>
                        <VMOption>-server</VMOption>
                        <VMOption>-Djava.net.preferIPv4Stack=true</VMOption>
                </VMOptions>
            </Tune>
      </Root>
  - owner: wowza:wowza
    path: /home/wowza/WowzaStreamingEngine/conf/VHost.xml
    content: |
      <?xml version="1.0" encoding="UTF-8"?>
      <Root version="2">
              <VHost>
                      <Description></Description>
                      <HostPortList>
                              <HostPort>
                                      <Name>Default SSL Streaming</Name>
                                      <Type>Streaming</Type>
                                      <ProcessorCount>$${com.wowza.wms.TuningAuto}</ProcessorCount>
                                      <IpAddress>*</IpAddress>
                                      <Port>443</Port>
                                      <HTTPIdent2Response></HTTPIdent2Response>
                                      <SSLConfig>
                                              <Enable>true</Enable>
                                              <KeyStorePath>/usr/local/WowzaStreamingEngine/conf/ssl.wowza.jks</KeyStorePath>
                                              <KeyStorePassword>${certPassword}</KeyStorePassword>
                                              <KeyStoreType>JKS</KeyStoreType>
                                              <DomainToKeyStoreMapPath></DomainToKeyStoreMapPath>
                                              <SSLProtocol>TLS</SSLProtocol>
                                              <Algorithm>SunX509</Algorithm>
                                              <CipherSuites></CipherSuites>
                                              <Protocols>TLSv1.2</Protocols>
                                      </SSLConfig>
                                      <SocketConfiguration>
                                              <ReuseAddress>true</ReuseAddress>
                                              <ReceiveBufferSize>0</ReceiveBufferSize>
                                              <ReadBufferSize>65000</ReadBufferSize>
                                              <SendBufferSize>0</SendBufferSize>
                                              <KeepAlive>true</KeepAlive>
                                              <AcceptorBackLog>100</AcceptorBackLog>
                                      </SocketConfiguration>
                                      <HTTPStreamerAdapterIDs></HTTPStreamerAdapterIDs>
                                      <HTTPProviders>
                                              <HTTPProvider>
                                                      <BaseClass>com.wowza.wms.http.HTTPCrossdomain</BaseClass>
                                                      <RequestFilters>*crossdomain.xml</RequestFilters>
                                                      <AuthenticationMethod>none</AuthenticationMethod>
                                              </HTTPProvider>
                                              <HTTPProvider>
                                                      <BaseClass>com.wowza.wms.http.HTTPClientAccessPolicy</BaseClass>
                                                      <RequestFilters>*clientaccesspolicy.xml</RequestFilters>
                                                      <AuthenticationMethod>none</AuthenticationMethod>
                                              </HTTPProvider>
                                              <HTTPProvider>
                                                      <BaseClass>com.wowza.wms.http.HTTPProviderMediaList</BaseClass>
                                                      <RequestFilters>*jwplayer.rss|*jwplayer.smil|*medialist.smil|*manifest-rtmp.f4m</RequestFilters>
                                                      <AuthenticationMethod>none</AuthenticationMethod>
                                              </HTTPProvider>
                                              <HTTPProvider>
                                                      <BaseClass>com.wowza.wms.http.HTTPServerVersion</BaseClass>
                                                      <RequestFilters>*</RequestFilters>
                                                      <AuthenticationMethod>none</AuthenticationMethod>
                                              </HTTPProvider>
                                      </HTTPProviders>
                              </HostPort>
                              <HostPort>
                                      <Name>Default Admin</Name>
                                      <Type>Admin</Type>
                                      <ProcessorCount>$${com.wowza.wms.TuningAuto}</ProcessorCount>
                                      <IpAddress>*</IpAddress>
                                      <Port>8086</Port>
                                      <HTTPIdent2Response></HTTPIdent2Response>
                                      <SocketConfiguration>
                                              <ReuseAddress>true</ReuseAddress>
                                              <ReceiveBufferSize>16000</ReceiveBufferSize>
                                              <ReadBufferSize>16000</ReadBufferSize>
                                              <SendBufferSize>16000</SendBufferSize>
                                              <KeepAlive>true</KeepAlive>
                                              <AcceptorBackLog>100</AcceptorBackLog>
                                      </SocketConfiguration>
                                      <HTTPStreamerAdapterIDs></HTTPStreamerAdapterIDs>
                                      <HTTPProviders>
                                              <HTTPProvider>
                                                      <BaseClass>com.wowza.wms.http.streammanager.HTTPStreamManager</BaseClass>
                                                      <RequestFilters>streammanager*</RequestFilters>
                                                      <AuthenticationMethod>admin-digest</AuthenticationMethod>
                                              </HTTPProvider>
                                              <HTTPProvider>
                                                      <BaseClass>com.wowza.wms.http.HTTPServerInfoXML</BaseClass>
                                                      <RequestFilters>serverinfo*</RequestFilters>
                                                      <AuthenticationMethod>admin-digest</AuthenticationMethod>
                                              </HTTPProvider>
                                              <HTTPProvider>
                                                      <BaseClass>com.wowza.wms.http.HTTPConnectionInfo</BaseClass>
                                                      <RequestFilters>connectioninfo*</RequestFilters>
                                                      <AuthenticationMethod>admin-digest</AuthenticationMethod>
                                              </HTTPProvider>
                                              <HTTPProvider>
                                                      <BaseClass>com.wowza.wms.http.HTTPConnectionCountsXML</BaseClass>
                                                      <RequestFilters>connectioncounts*</RequestFilters>
                                                      <AuthenticationMethod>admin-digest</AuthenticationMethod>
                                              </HTTPProvider>
                                              <HTTPProvider>
                                                      <BaseClass>com.wowza.wms.transcoder.httpprovider.HTTPTranscoderThumbnail</BaseClass>
                                                      <RequestFilters>transcoderthumbnail*</RequestFilters>
                                                      <AuthenticationMethod>admin-digest</AuthenticationMethod>
                                              </HTTPProvider>
                                              <HTTPProvider>
                                                      <BaseClass>com.wowza.wms.http.HTTPProviderMediaList</BaseClass>
                                                      <RequestFilters>medialist*</RequestFilters>
                                                      <AuthenticationMethod>admin-digest</AuthenticationMethod>
                                              </HTTPProvider>
                                              <HTTPProvider>
                                                      <BaseClass>com.wowza.wms.livestreamrecord.http.HTTPLiveStreamRecord</BaseClass>
                                                      <RequestFilters>livestreamrecord*</RequestFilters>
                                                      <AuthenticationMethod>admin-digest</AuthenticationMethod>
                                              </HTTPProvider>
                                              <HTTPProvider>
                                                      <BaseClass>com.wowza.wms.http.HTTPServerVersion</BaseClass>
                                                      <RequestFilters>*</RequestFilters>
                                                      <AuthenticationMethod>none</AuthenticationMethod>
                                              </HTTPProvider>
                                      </HTTPProviders>
                              </HostPort>
                      </HostPortList>
                      <HTTPStreamerAdapters></HTTPStreamerAdapters>
                      <!-- When set to zero, thread pool configuration is done in Server.xml -->
                      <HandlerThreadPool>
                              <PoolSize>0</PoolSize>
                      </HandlerThreadPool>
                      <TransportThreadPool>
                              <PoolSize>0</PoolSize>
                      </TransportThreadPool>
                      <IdleWorkers>
                              <WorkerCount>$${com.wowza.wms.TuningAuto}</WorkerCount>
                              <CheckFrequency>50</CheckFrequency>
                              <MinimumWaitTime>5</MinimumWaitTime>
                      </IdleWorkers>
                      <NetConnections>
                              <ProcessorCount>$${com.wowza.wms.TuningAuto}</ProcessorCount>
                              <IdleFrequency>250</IdleFrequency>
                              <SocketConfiguration>
                                      <ReuseAddress>true</ReuseAddress>
                                      <ReceiveBufferSize>0</ReceiveBufferSize>
                                      <ReadBufferSize>65000</ReadBufferSize>
                                      <SendBufferSize>0</SendBufferSize>
                                      <KeepAlive>true</KeepAlive>
                                      <!-- <TrafficClass>0</TrafficClass> -->
                                      <!-- <OobInline>false</OobInline> -->
                                      <!-- <SoLingerTime>-1</SoLingerTime> -->
                                      <!-- <TcpNoDelay>false</TcpNoDelay> -->
                                      <AcceptorBackLog>100</AcceptorBackLog>
                              </SocketConfiguration>
                      </NetConnections>
                      <MediaCasters>
                              <ProcessorCount>$${com.wowza.wms.TuningAuto}</ProcessorCount>
                              <SocketConfiguration>
                                      <ReuseAddress>true</ReuseAddress>
                                      <ReceiveBufferSize>65000</ReceiveBufferSize>
                                      <ReadBufferSize>65000</ReadBufferSize>
                                      <SendBufferSize>65000</SendBufferSize>
                                      <KeepAlive>true</KeepAlive>
                                      <!-- <TrafficClass>0</TrafficClass> -->
                                      <!-- <OobInline>false</OobInline> -->
                                      <!-- <SoLingerTime>-1</SoLingerTime> -->
                                      <!-- <TcpNoDelay>false</TcpNoDelay> -->
                                      <ConnectionTimeout>10000</ConnectionTimeout>
                              </SocketConfiguration>
                      </MediaCasters>
                      <LiveStreamTranscoders>
                              <MaximumConcurrentTranscodes>0</MaximumConcurrentTranscodes>
                      </LiveStreamTranscoders>
                      <HTTPTunnel>
                              <KeepAliveTimeout>2000</KeepAliveTimeout>
                      </HTTPTunnel>
                      <Client>
                              <ClientTimeout>90000</ClientTimeout>
                              <IdleFrequency>250</IdleFrequency>
                      </Client>
                      <!-- RTP/Authentication/Methods defined in Authentication.xml. Default setup includes; none, basic, digest -->
                      <RTP>
                              <IdleFrequency>75</IdleFrequency>
                              <DatagramConfiguration>
                                      <Incoming>
                                              <ReuseAddress>true</ReuseAddress>
                                              <ReceiveBufferSize>2048000</ReceiveBufferSize>
                                              <SendBufferSize>65000</SendBufferSize>
                                              <!-- <MulticastBindToAddress>true</MulticastBindToAddress> -->
                                              <!-- <MulticastInterfaceAddress>192.168.1.22</MulticastInterfaceAddress> -->
                                              <!-- <TrafficClass>0</TrafficClass> -->
                                              <MulticastTimeout>50</MulticastTimeout>
                                              <DatagramMaximumPacketSize>4096</DatagramMaximumPacketSize>
                                      </Incoming>
                                      <Outgoing>
                                              <ReuseAddress>true</ReuseAddress>
                                              <ReceiveBufferSize>65000</ReceiveBufferSize>
                                              <SendBufferSize>256000</SendBufferSize>
                                              <!-- <MulticastBindToAddress>true</MulticastBindToAddress> -->
                                              <!-- <MulticastInterfaceAddress>192.168.1.22</MulticastInterfaceAddress> -->
                                              <!-- <TrafficClass>0</TrafficClass> -->
                                              <MulticastTimeout>50</MulticastTimeout>
                                              <DatagramMaximumPacketSize>4096</DatagramMaximumPacketSize>
                                              <SendIGMPJoinMsgOnPublish>false</SendIGMPJoinMsgOnPublish>
                                      </Outgoing>
                              </DatagramConfiguration>
                              <UnicastIncoming>
                                      <ProcessorCount>$${com.wowza.wms.TuningAuto}</ProcessorCount>
                              </UnicastIncoming>
                              <UnicastOutgoing>
                                      <ProcessorCount>$${com.wowza.wms.TuningAuto}</ProcessorCount>
                              </UnicastOutgoing>
                              <MulticastIncoming>
                                      <ProcessorCount>$${com.wowza.wms.TuningAuto}</ProcessorCount>
                              </MulticastIncoming>
                              <MulticastOutgoing>
                                      <ProcessorCount>$${com.wowza.wms.TuningAuto}</ProcessorCount>
                              </MulticastOutgoing>
                      </RTP>
                      <HTTPProvider>
                              <KeepAliveTimeout>2000</KeepAliveTimeout>
                              <KillConnectionTimeout>10000</KillConnectionTimeout>
                              <SlowConnectionBitrate>64000</SlowConnectionBitrate>
                              <IdleFrequency>250</IdleFrequency>
                      </HTTPProvider>
                      <WebSocket>
                              <MaximumMessageSize>512k</MaximumMessageSize>
                              <PacketFragmentationSize>0</PacketFragmentationSize>
                              <MaskOutgoingMessages>false</MaskOutgoingMessages>
                              <IdleFrequency>250</IdleFrequency>
                              <ValidationFrequency>20000</ValidationFrequency>
                              <MaximumPendingWriteBytes>0</MaximumPendingWriteBytes>
                              <PingTimeout>12000</PingTimeout>
                      </WebSocket>
                      <Application>
                              <ApplicationTimeout>60000</ApplicationTimeout>
                              <PingTimeout>12000</PingTimeout>
                              <UnidentifiedSessionTimeout>30000</UnidentifiedSessionTimeout>
                              <ValidationFrequency>20000</ValidationFrequency>
                              <MaximumPendingWriteBytes>0</MaximumPendingWriteBytes>
                              <MaximumSetBufferTime>60000</MaximumSetBufferTime>
                      </Application>
                      <StartStartupStreams>true</StartStartupStreams>
                      <Manager>
                              <TestPlayer>
                                      <IpAddress>$${com.wowza.cloud.platform.PLATFORM_METADATA_EXTERNAL_IP}</IpAddress>
                                      <!--changed for default cloud install. <IpAddress>$${com.wowza.wms.HostPort.IpAddress}</IpAddress>-->
                                      <Port>$${com.wowza.wms.HostPort.FirstStreamingPort}</Port>
                                      <SSLEnable>$${com.wowza.wms.HostPort.SSLEnable}</SSLEnable>
                              </TestPlayer>
                              <!-- Properties defined are used by the Manager -->
                              <Properties>
                              </Properties>
                      </Manager>
                      <!-- Properties defined here will be added to the IVHost.getProperties() collection -->
                      <Properties>
                      </Properties>
              </VHost>
      </Root>
  - owner: wowza:wowza
    path: /home/wowza/WowzaStreamingEngine/conf/Application.xml
    content: |
        <?xml version="1.0" encoding="UTF-8"?>
        <Root version="1">
                <Application>
                        <Name></Name>
                        <AppType>live</AppType>
                        <Description></Description>
                        <!-- Uncomment to set application level timeout values
                        <ApplicationTimeout>60000</ApplicationTimeout>
                        <PingTimeout>12000</PingTimeout>
                        <ValidationFrequency>8000</ValidationFrequency>
                        <MaximumPendingWriteBytes>0</MaximumPendingWriteBytes>
                        <MaximumSetBufferTime>60000</MaximumSetBufferTime>
                        <MaximumStorageDirDepth>25</MaximumStorageDirDepth>
                        -->
                        <Connections>
                                <AutoAccept>true</AutoAccept>
                                <AllowDomains></AllowDomains>
                        </Connections>
                        <!--
                                StorageDir path variables

                                $${com.wowza.wms.AppHome} - Application home directory
                                $${com.wowza.wms.ConfigHome} - Configuration home directory
                                $${com.wowza.wms.context.VHost} - Virtual host name
                                $${com.wowza.wms.context.VHostConfigHome} - Virtual host home directory
                                $${com.wowza.wms.context.Application} - Application name
                                $${com.wowza.wms.context.ApplicationInstance} - Application instance name

                        -->
                        <Streams>
                                <StreamType>live</StreamType>
                                <StorageDir>$${com.wowza.wms.context.VHostConfigHome}/content</StorageDir>
                                <KeyDir>$${com.wowza.wms.context.VHostConfigHome}/keys</KeyDir>
                                <!-- LiveStreamPacketizers (separate with commas): cupertinostreamingpacketizer, smoothstreamingpacketizer, sanjosestreamingpacketizer, mpegdashstreamingpacketizer, cupertinostreamingrepeater, smoothstreamingrepeater, sanjosestreamingrepeater, mpegdashstreamingrepeater, dvrstreamingpacketizer, dvrstreamingrepeater -->
                                <LiveStreamPacketizers></LiveStreamPacketizers>
                                <!-- Properties defined here will override any properties defined in conf/Streams.xml for any streams types loaded by this application -->
                                <Properties>
                                </Properties>
                        </Streams>
                        <Transcoder>
                                <!-- To turn on transcoder set to: transcoder -->
                                <LiveStreamTranscoder></LiveStreamTranscoder>
                                <!-- [templatename].xml or $${SourceStreamName}.xml -->
                                <Templates>$${SourceStreamName}.xml,transrate.xml</Templates>
                                <ProfileDir>$${com.wowza.wms.context.VHostConfigHome}/transcoder/profiles</ProfileDir>
                                <TemplateDir>$${com.wowza.wms.context.VHostConfigHome}/transcoder/templates</TemplateDir>
                                <Properties>
                                </Properties>
                        </Transcoder>

                        <DVR>
                                <!-- As a single server or as an origin, use dvrstreamingpacketizer in LiveStreamPacketizers above -->
                                <!-- Or, in an origin-edge configuration, edges use dvrstreamingrepeater in LiveStreamPacketizers above -->
                                <!-- As an origin, also add dvrchunkstreaming to HTTPStreamers below -->

                                <!-- If this is a dvrstreamingrepeater, define Application/Repeater/OriginURL to point back to the origin -->

                                <!-- To turn on DVR recording set Recorders to dvrrecorder.  This works with dvrstreamingpacketizer  -->
                                <Recorders></Recorders>

                                <!-- As a single server or as an origin, set the Store to dvrfilestorage-->
                                <!-- edges should have this empty -->
                                <Store></Store>

                                <!--  Window Duration is length of live DVR window in seconds.  0 means the window is never trimmed. -->
                                <WindowDuration>0</WindowDuration>

                                <!-- Storage Directory is top level location where dvr is stored.  e.g. c:/temp/dvr -->
                                <StorageDir>$${com.wowza.wms.context.VHostConfigHome}/dvr</StorageDir>

                                <!-- valid ArchiveStrategy values are append, version, delete -->
                                <ArchiveStrategy>append</ArchiveStrategy>

                                <!-- Properties for DVR -->
                                <Properties>
                                </Properties>
                        </DVR>

                        <TimedText>
                                <!-- VOD caption providers (separate with commas): vodcaptionprovidermp4_3gpp, vodcaptionproviderttml, vodcaptionproviderwebvtt,  vodcaptionprovidersrt, vodcaptionproviderscc -->
                                <VODTimedTextProviders></VODTimedTextProviders>

                                <!-- Properties for TimedText -->
                                <Properties>
                                </Properties>
                        </TimedText>

                        <!-- HTTPStreamers (separate with commas): cupertinostreaming, smoothstreaming, sanjosestreaming, mpegdashstreaming, dvrchunkstreaming -->
                        <HTTPStreamers>cupertinostreaming,smoothstreaming,sanjosestreaming,mpegdashstreaming</HTTPStreamers>
                        <MediaCache>
                                <MediaCacheSourceList></MediaCacheSourceList>
                        </MediaCache>
                        <SharedObjects>
                                <StorageDir>$${com.wowza.wms.context.VHostConfigHome}/applications/$${com.wowza.wms.context.Application}/sharedobjects/$${com.wowza.wms.context.ApplicationInstance}</StorageDir>
                        </SharedObjects>
                        <Client>
                                <IdleFrequency>-1</IdleFrequency>
                                <Access>
                                        <StreamReadAccess>*</StreamReadAccess>
                                        <StreamWriteAccess>*</StreamWriteAccess>
                                        <StreamAudioSampleAccess></StreamAudioSampleAccess>
                                        <StreamVideoSampleAccess></StreamVideoSampleAccess>
                                        <SharedObjectReadAccess>*</SharedObjectReadAccess>
                                        <SharedObjectWriteAccess>*</SharedObjectWriteAccess>
                                </Access>
                        </Client>
                        <RTP>
                                <!-- RTP/Authentication/[type]Methods defined in Authentication.xml. Default setup includes; none, basic, digest -->
                                <Authentication>
                                        <PublishMethod>block</PublishMethod>
                                        <PlayMethod>none</PlayMethod>
                                </Authentication>
                                <!-- RTP/AVSyncMethod. Valid values are: senderreport, systemclock, rtptimecode -->
                                <AVSyncMethod>senderreport</AVSyncMethod>
                                <MaxRTCPWaitTime>12000</MaxRTCPWaitTime>
                                <IdleFrequency>75</IdleFrequency>
                                <RTSPSessionTimeout>90000</RTSPSessionTimeout>
                                <RTSPMaximumPendingWriteBytes>0</RTSPMaximumPendingWriteBytes>
                                <RTSPBindIpAddress></RTSPBindIpAddress>
                                <RTSPConnectionIpAddress>0.0.0.0</RTSPConnectionIpAddress>
                                <RTSPOriginIpAddress>127.0.0.1</RTSPOriginIpAddress>
                                <IncomingDatagramPortRanges>*</IncomingDatagramPortRanges>
                                <!-- Properties defined here will override any properties defined in conf/RTP.xml for any depacketizers loaded by this application -->
                                <Properties>
                                </Properties>
                        </RTP>
                        <MediaCaster>
                                <RTP>
                                        <RTSP>
                                                <!-- udp, interleave -->
                                                <RTPTransportMode>interleave</RTPTransportMode>
                                        </RTSP>
                                </RTP>
                                <StreamValidator>
                                        <Enable>true</Enable>
                                        <ResetNameGroups>true</ResetNameGroups>
                                        <StreamStartTimeout>20000</StreamStartTimeout>
                                        <StreamTimeout>12000</StreamTimeout>
                                        <VideoStartTimeout>0</VideoStartTimeout>
                                        <VideoTimeout>0</VideoTimeout>
                                        <AudioStartTimeout>0</AudioStartTimeout>
                                        <AudioTimeout>0</AudioTimeout>
                                        <VideoTCToleranceEnable>false</VideoTCToleranceEnable>
                                        <VideoTCPosTolerance>3000</VideoTCPosTolerance>
                                        <VideoTCNegTolerance>-500</VideoTCNegTolerance>
                                        <AudioTCToleranceEnable>false</AudioTCToleranceEnable>
                                        <AudioTCPosTolerance>3000</AudioTCPosTolerance>
                                        <AudioTCNegTolerance>-500</AudioTCNegTolerance>
                                        <DataTCToleranceEnable>false</DataTCToleranceEnable>
                                        <DataTCPosTolerance>3000</DataTCPosTolerance>
                                        <DataTCNegTolerance>-500</DataTCNegTolerance>
                                        <AVSyncToleranceEnable>false</AVSyncToleranceEnable>
                                        <AVSyncTolerance>1500</AVSyncTolerance>
                                        <DebugLog>false</DebugLog>
                                </StreamValidator>
                                <!-- Properties defined here will override any properties defined in conf/MediaCasters.xml for any MediaCasters loaded by this applications -->
                                <Properties>
                                </Properties>
                        </MediaCaster>
                        <MediaReader>
                                <!-- Properties defined here will override any properties defined in conf/MediaReaders.xml for any MediaReaders loaded by this applications -->
                                <Properties>
                                </Properties>
                        </MediaReader>
                        <MediaWriter>
                                <!-- Properties defined here will override any properties defined in conf/MediaWriter.xml for any MediaWriter loaded by this applications -->
                                <Properties>
                                </Properties>
                        </MediaWriter>
                        <LiveStreamPacketizer>
                                <!-- Properties defined here will override any properties defined in conf/LiveStreamPacketizers.xml for any LiveStreamPacketizers loaded by this applications -->
                                <Properties>
                                </Properties>
                        </LiveStreamPacketizer>
                        <HTTPStreamer>
                                <!-- Properties defined here will override any properties defined in conf/HTTPStreamers.xml for any HTTPStreamer loaded by this applications -->
                                <Properties>
                                </Properties>
                        </HTTPStreamer>
                        <Manager>
                                <!-- Properties defined are used by the Manager -->
                                <Properties>
                                </Properties>
                        </Manager>
                        <Repeater>
                                <OriginURL></OriginURL>
                                <QueryString><![CDATA[]]></QueryString>
                        </Repeater>
                        <StreamRecorder>
                                <Properties>
                                        <Property>
                                                <Name>streamRecorderFileVersionDelegate</Name>
                                                <Value>LiveStreamRecordFileVersionDelegate</Value>
                                                <Type>String</Type>
                                        </Property>
                                        <Property>
                                                <Name>streamRecorderFileVersionTemplate</Name>
                                                <Value>$${SourceStreamName}_$${RecordingStartTime}_$${SegmentNumber}</Value>
                                                <Type>String</Type>
                                        </Property>
                                        <Property>
                                                <Name>streamRecorderSegmentationType</Name>
                                                <Value>duration</Value>
                                                <Type>String</Type>
                                        </Property>
                                        <Property>
                                                <Name>streamRecorderSegmentDuration</Name>
                                                <Value>20000000</Value>
                                                <Type>long</Type>
                                        </Property>
                                </Properties>
                        </StreamRecorder>
                        <Modules>
                                <Module>
                                        <Name>base</Name>
                                        <Description>Base</Description>
                                        <Class>com.wowza.wms.module.ModuleCore</Class>
                                </Module>
                                <Module>
                                        <Name>logging</Name>
                                        <Description>Client Logging</Description>
                                        <Class>com.wowza.wms.module.ModuleClientLogging</Class>
                                </Module>
                                <Module>
                                        <Name>flvplayback</Name>
                                        <Description>FLVPlayback</Description>
                                        <Class>com.wowza.wms.module.ModuleFLVPlayback</Class>
                                </Module>
                                <Module>
                                        <Name>ModuleCoreSecurity</Name>
                                        <Description>Core Security Module for Applications</Description>
                                        <Class>com.wowza.wms.security.ModuleCoreSecurity</Class>
                                </Module>
                                <Module>
                                        <Name>ModuleAutoRecord</Name>
                                        <Description>Auto-record streams that are published to this application instance.</Description>
                                        <Class>com.wowza.wms.plugin.ModuleAutoRecord</Class>
                                </Module>
                                <Module>
                                	<Name>ModuleMediaWriterFileMover</Name>
                                        <Description>ModuleMediaWriterFileMover</Description>
                                        <Class>com.wowza.wms.module.ModuleMediaWriterFileMover</Class>
                                </Module>
                        </Modules>
                        <!-- Properties defined here will be added to the IApplication.getProperties() and IApplicationInstance.getProperties() collections -->
                        <Properties>
                                <Property>
                                        <Name>securityPublishRequirePassword</Name>
                                        <Value>false</Value>
                                        <Type>Boolean</Type>
                                </Property>
                                <Property>
                                        <Name>securityPublishBlockDuplicateStreamNames</Name>
                                        <Value>true</Value>
                                        <Type>Boolean</Type>
                                </Property>
                                <Property>
                                        <Name>fileMoverDestinationPath</Name>
                                        <Value>/wowzadata/azurecopy</Value>
                                </Property>
                                <Property>
                                        <Name>fileMoverDeleteOriginal</Name>
                                        <Value>true</Value>
                                        <Type>Boolean</Type>
                                </Property>
                                <Property>
                                        <Name>fileMoverVersionFile</Name>
                                        <Value>true</Value>
                                        <Type>Boolean</Type>
                                </Property>
                        </Properties>
                </Application>
        </Root>
  - owner: wowza:wowza
    path: /home/wowza/mount.sh
    permissions: 0775
    content: |
        #!/bin/bash

        # This Script Should Be Run As ROOT!

        mkdir -p $1 $3

        mountsTmp='/home/wowza/mounts.txt'
        df -h > $mountsTmp

        if grep -q "$(realpath $1)" $mountsTmp && grep -q "blobfuse" $mountsTmp; then
           echo "Blob IS Mounted."
        else
           echo "Blob IS NOT Mounted, Mounting Blob Fuse..."
           blobfuse $1 --tmp-path=$3 -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120 --file-cache-timeout-in-seconds=0 --config-file=$2 -o allow_other -o nonempty
        fi

        rm -f $mountsTmp
  - owner: wowza:wowza
    path: /home/wowza/recordings.cfg
    content: |
      accountName ${storageAccountName}
      containerName ${storageContainerName}
      authType MSI
      identityClientId ${msiClientId}
  - owner: wowza:wowza
    path: /home/wowza/wowzaapps.cfg
    content: |
      accountName ${storageAccountName}
      containerName wowzaapps
      authType MSI
      identityClientId ${msiClientId}
  - owner: wowza:wowza
    path: /home/wowza/wowzaconf.cfg
    content: |
      accountName ${storageAccountName}
      containerName wowzaconf
      authType MSI
      identityClientId ${msiClientId}
  - owner: wowza:wowza
    path: /home/wowza/migrateWowzaToDisk.sh
    content: |
      cp /home/wowza/WowzaStreamingEngine/conf/Server.xml /usr/local/WowzaStreamingEngine/conf/Server.xml
      cp /home/wowza/WowzaStreamingEngine/conf/VHost.xml /usr/local/WowzaStreamingEngine/conf/VHost.xml
      cp /home/wowza/WowzaStreamingEngine/conf/Application.xml /usr/local/WowzaStreamingEngine/conf/Application.xml
      cp /home/wowza/WowzaStreamingEngine/conf/admin.password /usr/local/WowzaStreamingEngine/conf/admin.password
      cp /home/wowza/WowzaStreamingEngine/conf/publish.password /usr/local/WowzaStreamingEngine/conf/publish.password
  - owner: wowza:wowza
    permissions: 0775
    path: /home/wowza/mountBlobFuse.sh
    content: |
      rm -r -f /wowzadata/blobfusetmp
      mkdir -p /wowzadata/blobfusetmp
      mkdir -p /wowzadata/azurecopy

      bash /home/wowza/mount.sh /wowzadata/azurecopy /home/wowza/recordings.cfg /wowzadata/blobfusetmp
  - owner: wowza:wowza
    path: /home/wowza/WowzaStreamingEngine/conf/admin.password
    content: |
      # Admin password file (format [username][space][password])
      #username password group|group
      wowza ${restPassword} admin
  - owner: wowza:wowza
    path: /home/wowza/WowzaStreamingEngine/conf/publish.password
    content: |
      # Publish password file (format [username][space][password])
      #username password
      wowza ${streamPassword}
  - owner: wowza:wowza
    permissions: 0775
    path: /home/wowza/check-file-size.sh
    content: |
        #!/bin/bash

        # Project
        project="VH"

        # Set Log Path.
        logFolder="/home/wowza/logs"
        logPath="/home/wowza/logs/check-file-size.log"

        # Set Dynatrace Details.
        dynatrace_token="${dynatrace_token}"
        dynatrace_tenant="${dynatrace_tenant}"

        # test 
        size="1MB"
        date="_$(date '+%Y-%m-%d')-"
        fileName="*$date*"
        sourcePath="/wowzadata/azurecopy/"
        foundItems=$(find $sourcePath -type f -name  $fileName  -size -1M;)

        # Set logs
        NOW=`date '+%F %H:%M:%S'`
        mkdir -p $logFolder
        touch $logPath

        echo "Starting Check at $NOW" >> $logPath
        if [ -z "$foundItems" ]; then
                echo "No files under $size found today" >> $logPath
        else
                echo "Files under $size found" >> $logPath
                echo "$foundItems" >> $logPath
                curl --location --request POST "https://$dynatrace_tenant.live.dynatrace.com/api/v2/events/ingest" \
                --header "Authorization: API-Token $dynatrace_token" \
                --header 'Content-Type: application/json' \
                --data-raw "{
                        \"eventType\": \"ERROR_EVENT\",
                        \"title\": \"FH - $project - Files under $size\",
                        \"entitySelector\": \"type(HOST),entityName.startsWith($HOSTNAME)\",
                        \"properties\": {
                        \"Size\": \"$size\",
                        \"Files\": \"$foundItems\"
                        }
                }" >> $logPath
        fi
  - owner: wowza:wowza
    permissions: 0775
    path: /home/wowza/check-blobMount.sh
    content: |
        #!/bin/bash

        # Project
        project="VH"

        # Set Dynatrace Details.
        dynatrace_token="${dynatrace_token}"
        dynatrace_tenant="${dynatrace_tenant}"

        # Set Log Path.
        logFolder="/home/wowza/logs"
        logPath="/home/wowza/logs/blobfuseMounted.log"

        # Minimum number of files the directory must contain
        limit=100

        # Get the number of files in the Wowza directory
        number_of_files=$(ls /wowzadata/azurecopy| wc -l)

        # Send Alert to Dynatrace if Azure storage is not mounted.
        NOW=`date '+%F %H:%M:%S'`
        mkdir -p $logFolder
        touch $logPath

        echo "Starting Azure Blob mount Check at $NOW" >> $logPath
        if (($number_of_files < $limit)); then
                echo "Blob Storage NOT mounted"  >> $logPath

                curl --location --request POST "https://$dynatrace_tenant.live.dynatrace.com/api/v2/events/ingest" \
                                --header "Authorization: API-Token $dynatrace_token" \
                                --header 'Content-Type: application/json' \
                                --data-raw "{
                                        \"eventType\": \"ERROR_EVENT\",
                                        \"title\": \"FH - $project - Wowza BlobStorage UnMounted\",
                                        \"entitySelector\": \"type(HOST),entityName.startsWith($HOSTNAME)\",
                                        \"properties\": {}
                                }" >> $logPath
        else
                echo "Found $number_of_files in /wowzadata/azurecopy - Blob Storage IS mounted." >> $logPath
        fi
  - owner: wowza:wowza
    permissions: 0775
    path: /home/wowza/check-cert.sh
    content: |
        #!/bin/bash

        # Project
        project="VH" 

        # Set Dynatrace Details.
        dynatrace_token="${dynatrace_token}"
        dynatrace_tenant="${dynatrace_tenant}"

        # Java Key Store Details.
        jksPath="/usr/local/WowzaStreamingEngine/conf/ssl.wowza.jks"
        jksPass="${certPassword}"

        # Set Log Path.
        logFolder="/home/wowza/logs"
        logPath="/home/wowza/logs/check-cert.log"

        # Wowza Engine Path.
        export PATH=$PATH:/usr/local/WowzaStreamingEngine/java/bin

        # Get Certificate Expiry Date.
        expiryDate=$(keytool -list -v -keystore $jksPath -storepass $jksPass | grep until | head -1 | sed 's/.*until: //')
        echo "Certificate Expires $expiryDate"
        certExpiryDate=$expiryDate
        expiryDate="$(date -d "$expiryDate - 12 days" +%Y%m%d)"
        echo "Certificate Forced Expiry is $expiryDate"
        today=$(date +%Y%m%d)

        # Send Alert to Dynatrace if Expirary Date within 12 Days.
        NOW=`date '+%F %H:%M:%S'`
        mkdir -p $logFolder
        touch $logPath

        echo "Starting Check at $NOW" >> $logPath
        if [[ $expiryDate -lt $today ]]; then
                echo "Wowza Certificate Has Expired" >> $logPath
                curl --location --request POST "https://$dynatrace_tenant.live.dynatrace.com/api/v2/events/ingest" \
                --header "Authorization: API-Token $dynatrace_token" \
                --header 'Content-Type: application/json' \
                --data-raw "{
                        \"eventType\": \"ERROR_EVENT\",
                        \"title\": \"FH - $project - Wowza Certificte Expiry\",
                        \"entitySelector\": \"type(HOST),entityName.startsWith($HOSTNAME)\",
                        \"properties\": {
                        \"Certificte.expiry\": \"$certExpiryDate\",
                        \"Certificte.renewal\": \"$expiryDate\"
                        }
                }" >> $logPath
        else
                echo "Wowza Certificate Has NOT Expired" >> $logPath
        fi
  - owner: wowza:wowza
    permissions: 0775
    path: /home/wowza/renew-cert.sh
    content: |
        #!/bin/bash

        miClientId="${managedIdentityClientId}"

        az login --identity --username $miClientId

        keyVaultName="${keyVaultName}"
        certName="${certName}"
        domain="${domain}"

        jksPath="/usr/local/WowzaStreamingEngine/conf/ssl.wowza.jks"
        jksPass="${certPassword}"

        export PATH=$PATH:/usr/local/WowzaStreamingEngine/java/bin

        expiryDate=$(keytool -list -v -keystore $jksPath -storepass $jksPass | grep until | head -1 | sed 's/.*until: //')

        echo "Certificate Expires $expiryDate"
        expiryDate="$(date -d "$expiryDate - 14 days" +%Y%m%d)"
        echo "Certificate Forced Expiry is $expiryDate"
        today=$(date +%Y%m%d)

        if [[ $expiryDate -lt $today ]]; then
            echo "Certificate has expired"
            downloadedPfxPath="downloadedCert.pfx"
            signedPfxPath="signedCert.pfx"
        
            rm -rf $downloadedPfxPath || true
            az keyvault secret download --file $downloadedPfxPath --vault-name $keyVaultName --encoding base64 --name $certName
            
            rm -rf $signedPfxPath || true
            openssl pkcs12 -in $downloadedPfxPath -out tmpmycert.pem -passin pass: -passout pass:$jksPass -nodes
            openssl pkcs12 -export -out $signedPfxPath -in tmpmycert.pem -passin pass:$jksPass -passout pass:$jksPass

            keytool -delete -alias 1 -keystore $jksPath -storepass $jksPass
            keytool -importkeystore -srckeystore $signedPfxPath -srcstoretype pkcs12 -destkeystore $jksPath -deststoretype JKS -deststorepass $jksPass -srcstorepass $jksPass
        else
            echo "Certificate has NOT expired"
        fi
  - owner: wowza:wowza
    path: /home/wowza/cron.sh
    permissions: 0775
    content: |
        #!/bin/bash
        # Prepare Script.
        cronTaskPath='/home/wowza/cronjobs.txt'
        cronTaskPathRoot='/home/wowza/cronjobsRoot.txt'

        # Cron For Mounting/Re-Mounting.
        logFolder='/home/wowza/logs'
        mkdir -p $logFolder
        echo "*/5 * * * * /home/wowza/mount.sh $1 $2 $3 >> $logFolder/wowza_mount.log 2>&1" >> $cronTaskPathRoot
        echo "0 0 * * * /home/wowza/renew-cert.sh >> $logFolder/renew-cert.log" >> $cronTaskPathRoot    

        # Cron For Certs. Filesizes and BlobMounts
        if [[ $HOSTNAME == *"prod"* ]] || [[ $HOSTNAME == *"stg"* ]]; then
          echo "10 0 * * * /home/wowza/check-cert.sh" >> $cronTaskPath
          echo "10 0 * * * /home/wowza/check-file-size.sh" >> $cronTaskPath
          echo "*/15 * * * * /home/wowza/check-blobMount.sh >> $cronTaskPath
        fi

        # Set Up Cron Jobs for Wowza & Root.
        crontab -u wowza $cronTaskPath
        crontab $cronTaskPathRoot
        
        # Remove To Avoid Duplicates.
        rm -f $cronTaskPath
        rm -f $cronTaskPathRoot
  - owner: wowza:wowza
    path: /home/wowza/wowza-setup.sh
    permissions: 0775
    content: |
        conferenceIds=("vh-recording-app")
        exampleDir="/home/wowza/Application.xml"
        rootDir="/usr/local/WowzaStreamingEngine"
        applicationFileName="Application.xml"

        for i in "$conferenceIds"; do
          conferenceId="$i"
          
          applicationDir="$rootDir/applications"
          contentDir="$rootDir/content"
          confDir="$rootDir/conf"
          confAppDir="$confDir/$conferenceId/$applicationFileName"

          mkdir -p "$applicationDir/$conferenceId"
          mkdir -p "$contentDir/$conferenceId"
          mkdir -p "$confDir/$conferenceId"

          cp $exampleDir $confAppDir
          chmod 755 $confAppDir
        done
  # PLEASE LEAVE THIS AT THE BOTTOM
  - owner: wowza:wowza
    permissions: 0775
    path: /home/wowza/runcmd.sh
    content: |
        #!/bin/bash
        # Inputs.
        blobMount="/wowzadata/azurecopy"
        blobTmp="/wowzadata/blobfusetmp"
        blobCfg="/home/wowza/recordings.cfg"
        logDir="/home/wowza/logs"

        # Create Log Dir
        mkdir -p $logDir && chown wowza:wowza $logDir

        # Migrate Wowza.
        sudo sh /home/wowza/migrateWowzaToDisk.sh
        wget https://www.wowza.com/downloads/forums/collection/wse-plugin-autorecord.zip && unzip wse-plugin-autorecord.zip && mv lib/wse-plugin-autorecord.jar /usr/local/WowzaStreamingEngine/lib/ && chown wowza: /usr/local/WowzaStreamingEngine/lib/wse-plugin-autorecord.jar
  
        # Mount Blob Fuse.
        /home/wowza/mount.sh $blobMount $blobCfg $blobTmp
        
        # Install Certs.
        sudo curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash # Az cli install
        sudo /home/wowza/renew-cert.sh

        # Set-up CronJobs.
        /home/wowza/cron.sh $blobMount $blobCfg $blobTmp

        # Create Wowza Application Folders/Files.
        /home/wowza/wowza-setup.sh

        # Restart Wowza.
        sudo service WowzaStreamingEngine restart
runcmd:
  - 'sudo /home/wowza/runcmd.sh'

final_message: "The system is finally up, after $UPTIME seconds"
