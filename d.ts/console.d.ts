interface Console {
    info(): void;
    info(message: any, ...optionalParams: any[]): void;
    profile(reportName?: string): boolean;
    assert(): void;
    assert(test: boolean): void;
    assert(test: boolean, message: any, ...optionalParams: any[]): void;
    clear(): boolean;
    dir(): boolean;
    dir(value: any, ...optionalParams: any[]): boolean;
    warn(): void;
    warn(message: any, ...optionalParams: any[]): void;
    error(): void;
    error(message: any, ...optionalParams: any[]): void;
    log(): void;
    log(message: any, ...optionalParams: any[]): void;
    profileEnd(): boolean;
}
declare var console: Console;
