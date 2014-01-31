export declare class One {
    public string_attr: string;
    public number_attr: number;
    private priv_attr;
    constructor(string_attr: string, number_attr: number);
    public method(): string;
}
export declare class Two extends One {
    public method(str?: string): string;
}
export declare var one: One;
export declare var two: Two;
